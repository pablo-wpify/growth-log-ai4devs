require "rails_helper"

RSpec.describe Person, type: :model do
  it "no se guarda sin nombre, ni por el modelo ni en la base" do
    expect(Person.new(name: "")).not_to be_valid
    expect { Person.new.save!(validate: false) }.to raise_error(ActiveRecord::NotNullViolation)
  end

  it "conserva nombre, rol y equipo" do
    person = create_person(name: "Ada Ejemplo", role: "Desarrolladora", team: "Equipo Faro")

    expect(person.reload).to have_attributes(name: "Ada Ejemplo", role: "Desarrolladora", team: "Equipo Faro")
  end

  it "queda activa al crearse sin indicar su estado" do
    expect(create_person).to be_active
  end

  it "al desactivarse se conserva junto con sus asignaciones activas" do
    person = create_person
    assignment = assign(create_user, person)

    person.update!(active: false)

    expect(Person.exists?(person.id)).to be(true)
    expect(assignment.reload.ended_at).to be_nil
  end

  it "filtra las personas activas" do
    active = create_person(name: "Ada Ejemplo")
    create_person(name: "Bruno Ejemplo", active: false)

    expect(Person.active).to contain_exactly(active)
  end
end
