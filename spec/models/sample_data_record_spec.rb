require "rails_helper"

# Marcas del conjunto ficticio (GL-08, P-13): restricciones de la base que
# impiden claves duplicadas, referencias ambiguas y marcas huérfanas.
RSpec.describe SampleDataRecord, type: :model do
  let(:user) { create_user(email_address: "elena.boceto@ficticio.example.test", name: "Elena Boceto") }
  let(:person) { create_person }
  let(:assignment) { assign(user, person) }

  def insert(**attributes)
    SampleDataRecord.new(**attributes).save!(validate: false)
  end

  it "guarda una marca por tipo con la clave de su prefijo" do
    insert(key: "account:elena", user: user)
    insert(key: "person:ada", person: person)
    insert(key: "assignment:elena/ada", assignment: assignment)

    expect(SampleDataRecord.count).to eq(3)
  end

  it "rechaza una clave duplicada" do
    insert(key: "account:elena", user: user)

    expect { insert(key: "account:elena", user: create_user(email_address: "otra@ficticio.example.test")) }
      .to raise_error(ActiveRecord::RecordNotUnique)
  end

  it "rechaza una marca sin referencia" do
    expect { insert(key: "account:elena") }.to raise_error(ActiveRecord::CheckViolation)
  end

  it "rechaza una marca con dos referencias" do
    expect { insert(key: "account:elena", user: user, person: person) }.to raise_error(ActiveRecord::CheckViolation)
  end

  it "rechaza un prefijo que no coincide con la referencia" do
    expect { insert(key: "person:elena", user: user) }.to raise_error(ActiveRecord::CheckViolation)
  end

  it "rechaza marcar dos veces el mismo registro" do
    insert(key: "account:elena", user: user)

    expect { insert(key: "account:elena-bis", user: user) }.to raise_error(ActiveRecord::RecordNotUnique)
  end

  it "rechaza una marca sin clave" do
    expect { insert(key: nil, user: user) }.to raise_error(ActiveRecord::NotNullViolation)
  end

  it "rechaza una referencia a un registro inexistente" do
    expect { insert(key: "account:elena", user_id: User.maximum(:id).to_i + 1000) }
      .to raise_error(ActiveRecord::InvalidForeignKey)
  end

  it "impide borrar un registro marcado" do
    insert(key: "person:ada", person: person)

    expect { Person.where(id: person.id).delete_all }.to raise_error(ActiveRecord::InvalidForeignKey)
  end
end
