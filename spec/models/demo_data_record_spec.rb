require "rails_helper"

# Marcas del conjunto demo (GL-10, P-31): tabla propia, separada de la de
# GL-08, con las mismas restricciones y referencias también a entradas.
RSpec.describe DemoDataRecord, type: :model do
  let(:user) { create_user(email_address: "lucia.demo@ficticio.example.test", name: "Lucía Demo") }
  let(:person) { create_person(name: "Paula Ejemplo") }
  let(:assignment) { assign(user, person) }
  let(:entry) { FeedbackEntry.create!(author: user, person: person, occurred_on: Time.zone.today, context: "Ejemplo ficticio.") }

  def insert(**attributes)
    DemoDataRecord.new(**attributes).save!(validate: false)
  end

  it "guarda una marca por tipo con la clave de su prefijo" do
    insert(key: "demo:account:lucia", user: user)
    insert(key: "demo:person:paula", person: person)
    insert(key: "demo:assignment:lucia/paula", assignment: assignment)
    insert(key: "demo:entry:lucia/borrador", feedback_entry: entry)

    expect(DemoDataRecord.count).to eq(4)
  end

  it "rechaza una clave duplicada" do
    insert(key: "demo:account:lucia", user: user)

    expect { insert(key: "demo:account:lucia", user: create_user(email_address: "otra@ficticio.example.test")) }
      .to raise_error(ActiveRecord::RecordNotUnique)
  end

  it "rechaza una marca sin referencia" do
    expect { insert(key: "demo:account:lucia") }.to raise_error(ActiveRecord::CheckViolation)
  end

  it "rechaza una marca con dos referencias" do
    expect { insert(key: "demo:account:lucia", user: user, person: person) }.to raise_error(ActiveRecord::CheckViolation)
  end

  it "rechaza un prefijo que no coincide con la referencia" do
    expect { insert(key: "demo:person:lucia", user: user) }.to raise_error(ActiveRecord::CheckViolation)
    expect { insert(key: "account:lucia", user: user) }.to raise_error(ActiveRecord::CheckViolation)
  end

  it "rechaza marcar dos veces el mismo registro" do
    insert(key: "demo:entry:a", feedback_entry: entry)

    expect { insert(key: "demo:entry:b", feedback_entry: entry) }.to raise_error(ActiveRecord::RecordNotUnique)
  end

  it "impide borrar un registro marcado" do
    insert(key: "demo:entry:lucia/borrador", feedback_entry: entry)

    expect { FeedbackEntry.where(id: entry.id).delete_all }.to raise_error(ActiveRecord::InvalidForeignKey)
  end
end
