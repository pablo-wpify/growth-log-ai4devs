require "rails_helper"

# Acceso a las entradas (GL-06; spec authorization). Lectura por autoría, sin
# depender de la asignación ni del estado de la persona (P-7, P-9). Escritura
# con autoría, asignación activa y persona activa (P-20). Ser administrador
# no da acceso (PP-8). Compartir no existe en este cambio.
RSpec.describe FeedbackEntryPolicy do
  let!(:l1) { create_user(email_address: "luis.lider@example.test", name: "Luis Líder") }
  let!(:l2) { create_user(email_address: "lara.lider@example.test", name: "Lara Líder") }
  let!(:l3) { create_user(email_address: "leo.lider@example.test", name: "Leo Líder") }
  let!(:admin) { create_user(email_address: "ana.admin@example.test", name: "Ana Admin", admin: true) }

  let!(:p) { create_person(name: "Ada Ejemplo") }
  let!(:assignment) { assign(l1, p) }

  let!(:draft) { create_entry(l1, p, context: "Borrador de Luis") }
  let!(:ready) { create_entry(l1, p, context: "Lista de Luis", status: "ready", dimension: "teamwork", signal: "positive") }

  before { assign(l2, p) }

  def create_entry(author, person, **attributes)
    FeedbackEntry.create!(author: author, person: person, occurred_on: Date.new(2026, 11, 12), context: "Texto", **attributes)
  end

  def scope_for(user)
    FeedbackEntryPolicy::Scope.new(user, FeedbackEntry.all).resolve
  end

  def permissions(user, entry)
    policy = described_class.new(user, entry)
    %i[show? new? create? edit? update? mark_ready?].index_with { |action| policy.public_send(action) }
  end

  def all_allowed = %i[show? new? create? edit? update? mark_ready?].index_with { true }
  def none_allowed = %i[show? new? create? edit? update? mark_ready?].index_with { false }
  def read_only = none_allowed.merge(show?: true)

  describe "autor con asignación activa" do
    it "puede leer y escribir su borrador y su entrada lista, y las dos están en su alcance" do
      expect(permissions(l1, draft)).to eq(all_allowed)
      expect(permissions(l1, ready)).to eq(all_allowed)
      expect(scope_for(l1)).to contain_exactly(draft, ready)
    end

    it "puede crear una entrada nueva sobre la persona" do
      expect(described_class.new(l1, FeedbackEntry.new(author: l1, person: p)).create?).to be(true)
    end
  end

  describe "otras cuentas (aislamiento, 4.11, PP-3, PP-4, PP-8)" do
    it "otro líder asignado a la misma persona no puede leer ni escribir y su alcance no incluye las entradas" do
      expect(permissions(l2, draft)).to eq(none_allowed)
      expect(permissions(l2, ready)).to eq(none_allowed)
      expect(scope_for(l2)).to be_empty
    end

    it "un líder sin asignación no tiene acceso" do
      expect(permissions(l3, draft)).to eq(none_allowed)
      expect(permissions(l3, ready)).to eq(none_allowed)
      expect(scope_for(l3)).to be_empty
    end

    it "una administradora sin asignación no tiene acceso" do
      expect(permissions(admin, draft)).to eq(none_allowed)
      expect(permissions(admin, ready)).to eq(none_allowed)
      expect(scope_for(admin)).to be_empty
    end

    it "una administradora asignada a la persona tampoco tiene acceso" do
      assign(admin, p)

      expect(permissions(admin, draft)).to eq(none_allowed)
      expect(permissions(admin, ready)).to eq(none_allowed)
      expect(scope_for(admin)).to be_empty
    end

    it "nadie crea una entrada a nombre de otra cuenta" do
      expect(described_class.new(l2, FeedbackEntry.new(author: l1, person: p)).create?).to be(false)
    end

    it "sin cuenta identificada no hay acceso" do
      expect(permissions(nil, draft)).to eq(none_allowed)
      expect(scope_for(nil)).to be_empty
    end
  end

  describe "asignación terminada (3.10, 4.14 parciales; lectura de entradas propias de PT-11)" do
    before { assignment.update!(ended_at: Time.current) }

    it "el autor sigue leyendo su borrador y su entrada lista, pero no escribe" do
      expect(permissions(l1, draft)).to eq(read_only)
      expect(permissions(l1, ready)).to eq(read_only)
      expect(scope_for(l1)).to contain_exactly(draft, ready)
    end

    it "no puede crear entradas nuevas sobre la persona" do
      expect(described_class.new(l1, FeedbackEntry.new(author: l1, person: p)).create?).to be(false)
    end
  end

  describe "persona inactiva (P-9, P-20)" do
    before { p.update!(active: false) }

    it "el autor conserva la lectura y pierde la escritura" do
      expect(permissions(l1, draft)).to eq(read_only)
      expect(permissions(l1, ready)).to eq(read_only)
      expect(scope_for(l1)).to contain_exactly(draft, ready)
    end
  end
end
