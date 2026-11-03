require "rails_helper"

# Conjunto ficticio de desarrollo (GL-08). Con el entorno inyectado; la
# comprobación con procesos reales está en spec/tasks/sample_data_process_spec.rb.
RSpec.describe DevelopmentSampleData do
  EXPECTED_ACCOUNTS = {
    "account:elena" => [ "elena.boceto@ficticio.example.test", "Elena Boceto", true ],
    "account:tomas" => [ "tomas.borrador@ficticio.example.test", "Tomás Borrador", true ],
    "account:ines" => [ "ines.muestra@ficticio.example.test", "Inés Muestra", true ],
    "account:raul" => [ "raul.pasado@ficticio.example.test", "Raúl Pasado", true ],
    "account:delia" => [ "delia.inactiva@ficticio.example.test", "Delia Inactiva", false ]
  }.freeze

  EXPECTED_PEOPLE = {
    "person:ada" => [ "Ada Ejemplo", true ],
    "person:bruno" => [ "Bruno Ejemplo", true ],
    "person:carla" => [ "Carla Ejemplo", true ],
    "person:dario" => [ "Darío Ejemplo", false ],
    "person:eva" => [ "Eva Ejemplo", true ]
  }.freeze

  EXPECTED_ASSIGNMENTS = {
    "assignment:elena/ada" => %w[account:elena person:ada active],
    "assignment:tomas/ada" => %w[account:tomas person:ada active],
    "assignment:elena/bruno" => %w[account:elena person:bruno active],
    "assignment:tomas/carla" => %w[account:tomas person:carla active],
    "assignment:elena/dario" => %w[account:elena person:dario active],
    "assignment:raul/bruno" => %w[account:raul person:bruno ended],
    "assignment:delia/ada" => %w[account:delia person:ada active]
  }.freeze

  describe "primera ejecución" do
    let!(:result) { run_sample_data }

    it "crea exactamente las cuentas, personas y asignaciones definidas, con sus marcas" do
      expect(result).to be_success
      expect(User.count).to eq(5)
      expect(Person.count).to eq(5)
      expect(Assignment.count).to eq(7)
      expect(SampleDataRecord.pluck(:key)).to match_array(EXPECTED_ACCOUNTS.keys + EXPECTED_PEOPLE.keys + EXPECTED_ASSIGNMENTS.keys)
      expect(result.created).to match_array(SampleDataRecord.pluck(:key))
      expect(result.existing).to be_empty
    end

    it "crea las cuentas con su correo, nombre y estado, ninguna administradora" do
      EXPECTED_ACCOUNTS.each do |key, (email, name, active)|
        user = sample_user(key)
        expect(user).to have_attributes(email_address: email, name: name, admin: false)
        expect(user.active?).to eq(active)
      end
    end

    it "crea las personas con su nombre y estado" do
      EXPECTED_PEOPLE.each do |key, (name, active)|
        expect(sample_person(key)).to have_attributes(name: name, active: active)
      end
    end

    it "crea las asignaciones entre los registros marcados, con la terminada" do
      EXPECTED_ASSIGNMENTS.each do |key, (account, person, state)|
        assignment = sample_assignment(key)
        expect(assignment.leader).to eq(sample_user(account))
        expect(assignment.person).to eq(sample_person(person))
        expect(assignment.ended_at.nil?).to eq(state == "active")
      end
    end

    it "deja cuentas cuya contraseña nadie conoce: un intento con una contraseña de prueba falla" do
      EXPECTED_ACCOUNTS.each_value do |email, _, _|
        expect(User.authenticate_by(email_address: email, password: generated_password)).to be_nil
      end
    end

    it "da el alcance de personas esperado con la política de GL-03" do
      scope = ->(key) { PersonPolicy::Scope.new(sample_user(key), Person.all).resolve.pluck(:name) }

      expect(scope.call("account:elena")).to contain_exactly("Ada Ejemplo", "Bruno Ejemplo")
      expect(scope.call("account:tomas")).to contain_exactly("Ada Ejemplo", "Carla Ejemplo")
      expect(scope.call("account:ines")).to be_empty
      expect(scope.call("account:raul")).to be_empty
      expect(User.active.where(id: sample_user("account:delia").id)).to be_empty
    end
  end

  it "genera un hash distinto en cada creación de una cuenta" do
    run_sample_data
    first = sample_user("account:elena").password_digest

    SampleDataRecord.delete_all
    Assignment.delete_all
    User.delete_all
    Person.delete_all
    run_sample_data

    expect(sample_user("account:elena").password_digest).not_to eq(first)
  end

  describe "repetición" do
    it "una segunda ejecución no crea, modifica ni borra nada" do
      run_sample_data
      before = sample_data_snapshot

      travel 1.hour do
        result = run_sample_data

        expect(result).to be_success
        expect(result.created).to be_empty
        expect(result.existing.size).to eq(17)
      end
      expect(sample_data_snapshot).to eq(before)
    end

    it "conserva los cambios manuales y no reactiva cuentas ni asignaciones" do
      run_sample_data
      elena = sample_user("account:elena")
      new_password = generated_password
      elena.update!(password: new_password, name: "Elena Cambiada", deactivated_at: Time.current)
      sample_person("person:carla").update!(active: false)
      sample_assignment("assignment:tomas/ada").update!(ended_at: Time.current)
      before = sample_data_snapshot

      run_sample_data

      expect(sample_data_snapshot).to eq(before)
      expect(elena.reload).not_to be_active
      expect(User.authenticate_by(email_address: elena.email_address, password: new_password)).to eq(elena)
      expect(Assignment.where(leader: sample_user("account:tomas"), person: sample_person("person:ada")).count).to eq(1)
      expect(Assignment.active.where(leader: sample_user("account:tomas"), person: sample_person("person:ada"))).to be_empty
    end

    it "crea solo lo que falta cuando hay elementos sin marca del conjunto" do
      run_sample_data
      SampleDataRecord.find_by!(key: "assignment:delia/ada").tap { |r| r.delete; Assignment.delete(r.assignment_id) }

      result = run_sample_data

      expect(result.created).to eq([ "assignment:delia/ada" ])
      expect(Assignment.count).to eq(7)
    end
  end

  describe "conflictos" do
    it "no adopta una cuenta ajena con un correo del conjunto y no escribe nada" do
      foreign = create_user(email_address: "tomas.borrador@ficticio.example.test", name: "Cuenta Ajena")
      digest = foreign.password_digest

      result = run_sample_data

      expect(result).not_to be_success
      expect(result.conflicts).to eq([ "account:tomas: ya existe una cuenta con tomas.borrador@ficticio.example.test que la tarea no creó" ])
      expect(User.count).to eq(1)
      expect([ Person.count, Assignment.count, SampleDataRecord.count ]).to eq([ 0, 0, 0 ])
      expect(foreign.reload).to have_attributes(name: "Cuenta Ajena", password_digest: digest, admin: false)
    end

    it "no crea una asignación si el par marcado ya tiene una activa sin marca" do
      run_sample_data
      record = SampleDataRecord.find_by!(key: "assignment:elena/ada")
      leader, person = record.assignment.leader, record.assignment.person
      record.delete
      before = sample_data_snapshot

      result = run_sample_data

      expect(result).not_to be_success
      expect(result.conflicts.first).to start_with("assignment:elena/ada:")
      expect(sample_data_snapshot).to eq(before)
      expect(Assignment.active.where(leader: leader, person: person).count).to eq(1)
    end

    it "revierte toda la operación ante un error a mitad de la creación" do
      calls = 0
      allow(Assignment).to receive(:create!).and_wrap_original do |original, *args, **kwargs|
        calls += 1
        raise ActiveRecord::StatementInvalid, "falla simulada" if calls == 3

        original.call(*args, **kwargs)
      end

      expect { run_sample_data }.to raise_error(ActiveRecord::StatementInvalid, "falla simulada")
      expect([ User.count, Person.count, Assignment.count, SampleDataRecord.count ]).to eq([ 0, 0, 0, 0 ])
    end
  end

  describe "entorno" do
    %w[test production].each do |name|
      it "se niega en #{name} sin consultar ni escribir la base" do
        queries = []
        callback = ->(*, payload) { queries << payload[:sql] unless payload[:name] == "SCHEMA" }

        result = ActiveSupport::Notifications.subscribed(callback, "sql.active_record") do
          run_sample_data(env: ActiveSupport::EnvironmentInquirer.new(name))
        end

        expect(result).to be_refused
        expect(queries).to be_empty
        expect(User.count + Person.count + Assignment.count + SampleDataRecord.count).to eq(0)
      end
    end
  end
end
