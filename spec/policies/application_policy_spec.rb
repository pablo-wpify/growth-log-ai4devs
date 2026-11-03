require "rails_helper"

# Denegación por defecto (GL-03): una política sin reglas propias deniega
# todo y su alcance está vacío.
RSpec.describe ApplicationPolicy do
  let(:user) { create_user }
  let(:record) { create_person }

  %i[index? show? create? new? update? edit? destroy?].each do |query|
    it "deniega #{query} sin una regla propia" do
      expect(described_class.new(user, record).public_send(query)).to be(false)
    end
  end

  it "deniega también a una cuenta administradora" do
    admin = create_user(email_address: "ana.admin@example.test", name: "Ana Admin", admin: true)

    expect(described_class.new(admin, record).show?).to be(false)
  end

  it "resuelve un alcance vacío sin una regla propia" do
    create_person

    expect(described_class::Scope.new(user, Person.all).resolve).to be_empty
  end
end
