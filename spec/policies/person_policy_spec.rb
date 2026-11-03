require "rails_helper"

# Acceso de un líder a una persona (GL-03, P-7, P-9): solo con asignación
# activa y persona activa. El rol de administrador no da acceso. Prueba la
# política y el alcance; la petición por URL directa llega con las rutas de
# personas de GL-05.
RSpec.describe PersonPolicy do
  let!(:l1) { create_user(email_address: "luis.lider@example.test", name: "Luis Líder") }
  let!(:l2) { create_user(email_address: "lara.lider@example.test", name: "Lara Líder") }
  let!(:l3) { create_user(email_address: "leo.lider@example.test", name: "Leo Líder") }
  let!(:admin) { create_user(email_address: "ana.admin@example.test", name: "Ana Admin", admin: true) }

  let!(:p) { create_person(name: "Ada Ejemplo") }
  let!(:q) { create_person(name: "Bruno Ejemplo") }
  let!(:inactive) { create_person(name: "Ceci Ejemplo", active: false) }

  before do
    assign(l1, p)
    assign(l2, p)
    assign(l1, inactive)
  end

  def scope_for(user)
    PersonPolicy::Scope.new(user, Person.all).resolve
  end

  def allowed?(user, person)
    described_class.new(user, person).show?
  end

  it "permite a un líder con asignación activa y la persona está en su alcance" do
    expect(allowed?(l1, p)).to be(true)
    expect(scope_for(l1)).to include(p)
  end

  it "permite a los dos líderes asignados a la misma persona" do
    expect(allowed?(l2, p)).to be(true)
    expect(scope_for(l1)).to include(p)
    expect(scope_for(l2)).to contain_exactly(p)
  end

  it "deniega a un líder sin asignación y la persona no está en su alcance" do
    expect(allowed?(l3, p)).to be(false)
    expect(allowed?(l1, q)).to be(false)
    expect(scope_for(l3)).to be_empty
  end

  it "deniega cuando termina la asignación" do
    Assignment.find_by!(leader: l2, person: p).update!(ended_at: Time.current)

    expect(allowed?(l2, p)).to be(false)
    expect(scope_for(l2)).to be_empty
  end

  it "deniega una persona inactiva aunque la asignación siga activa" do
    expect(Assignment.active.exists?(leader: l1, person: inactive)).to be(true)
    expect(allowed?(l1, inactive)).to be(false)
    expect(scope_for(l1)).to contain_exactly(p)
  end

  it "deniega a una administradora sin asignaciones y su alcance está vacío" do
    expect(allowed?(admin, p)).to be(false)
    expect(allowed?(admin, q)).to be(false)
    expect(scope_for(admin)).to be_empty
  end

  it "una administradora asignada a una sola persona ve solo esa, como cualquier líder" do
    assign(admin, q)

    expect(scope_for(admin)).to contain_exactly(q)
    expect(allowed?(admin, p)).to be(false)
  end

  it "deniega sin cuenta identificada" do
    expect(allowed?(nil, p)).to be(false)
    expect(scope_for(nil)).to be_empty
  end
end
