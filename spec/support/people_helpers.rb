# Ayudas de prueba para GL-03: personas y asignaciones con datos ficticios.
module PeopleHelpers
  def create_person(name: "Ada Ejemplo", **attributes)
    Person.create!(name: name, **attributes)
  end

  def assign(leader, person, started_at: 1.day.ago, ended_at: nil)
    Assignment.create!(leader: leader, person: person, started_at: started_at, ended_at: ended_at)
  end
end

RSpec.configure do |config|
  config.include PeopleHelpers
end
