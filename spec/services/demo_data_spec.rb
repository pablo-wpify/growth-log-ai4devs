require "rails_helper"

# Conjunto demo de la instancia temporal (GL-10, capability temporary-demo).
# Con el entorno y las variables inyectados; la comprobación con procesos
# reales está en spec/tasks/demo_data_process_spec.rb.
RSpec.describe DemoData do
  EXPECTED_DEMO_KEYS = %w[
    demo:person:paula
    demo:account:lucia demo:account:martin
    demo:assignment:lucia/paula demo:assignment:martin/paula
    demo:entry:lucia/borrador demo:entry:lucia/lista demo:entry:martin/lista
  ].freeze

  describe "primera ejecución" do
    let!(:result) { run_demo_data }

    it "crea exactamente el conjunto demo, con sus marcas propias" do
      expect(result).to be_success
      expect(demo_counts).to eq([ 2, 1, 2, 3, 8 ])
      expect(DemoDataRecord.pluck(:key)).to match_array(EXPECTED_DEMO_KEYS)
      expect(result.created).to match_array(EXPECTED_DEMO_KEYS)
      expect(result.existing).to be_empty
      expect(SampleDataRecord.count).to eq(0)
    end

    it "crea dos cuentas activas, no administradoras, en el dominio ficticio" do
      lucia = demo_record("demo:account:lucia").user
      martin = demo_record("demo:account:martin").user

      expect(lucia).to have_attributes(email_address: "lucia.demo@ficticio.example.test", name: "Lucía Demo", admin: false)
      expect(martin).to have_attributes(email_address: "martin.demo@ficticio.example.test", name: "Martín Demo", admin: false)
      expect([ lucia, martin ]).to all(be_active)
    end

    it "toma la contraseña inicial de cada cuenta de su variable secreta" do
      lucia = demo_record("demo:account:lucia").user
      martin = demo_record("demo:account:martin").user

      expect(lucia.authenticate(demo_passwords["GROWTH_LOG_DEMO_PASSWORD_LUCIA"])).to eq(lucia)
      expect(martin.authenticate(demo_passwords["GROWTH_LOG_DEMO_PASSWORD_MARTIN"])).to eq(martin)
      expect(lucia.authenticate(demo_passwords["GROWTH_LOG_DEMO_PASSWORD_MARTIN"])).to be(false)
    end

    it "asigna a Paula a los dos líderes" do
      paula = demo_record("demo:person:paula").person

      expect(paula).to have_attributes(name: "Paula Ejemplo", active: true)
      expect(Assignment.active.where(person: paula).map(&:leader)).to match_array(
        [ demo_record("demo:account:lucia").user, demo_record("demo:account:martin").user ]
      )
    end

    it "crea un borrador y una entrada lista de Lucía y una entrada lista de Martín, sobre Paula" do
      draft = demo_record("demo:entry:lucia/borrador").feedback_entry
      lucia_ready = demo_record("demo:entry:lucia/lista").feedback_entry
      martin_ready = demo_record("demo:entry:martin/lista").feedback_entry
      paula = demo_record("demo:person:paula").person

      expect(draft).to have_attributes(status: "draft", signal: nil, dimension: nil, person: paula,
        author: demo_record("demo:account:lucia").user)
      expect(lucia_ready).to have_attributes(status: "ready", signal: "positive", dimension: "teamwork", person: paula)
      expect(martin_ready).to have_attributes(status: "ready", signal: "improvement", dimension: "communication",
        person: paula, author: demo_record("demo:account:martin").user)
      expect([ draft, lucia_ready, martin_ready ].map(&:occurred_on)).to all(be < Time.zone.today)
    end

    it "deja a cada líder viendo solo sus propias entradas sobre Paula" do
      lucia = demo_record("demo:account:lucia").user
      martin = demo_record("demo:account:martin").user

      expect(FeedbackEntryPolicy::Scope.new(lucia, FeedbackEntry).resolve.count).to eq(2)
      expect(FeedbackEntryPolicy::Scope.new(martin, FeedbackEntry).resolve.count).to eq(1)
    end
  end

  describe "repetición" do
    it "una segunda ejecución no crea, modifica ni borra nada" do
      run_demo_data
      before = demo_snapshot

      result = run_demo_data

      expect(result).to be_success
      expect(result.created).to be_empty
      expect(result.existing).to match_array(EXPECTED_DEMO_KEYS)
      expect(demo_snapshot).to eq(before)
    end

    it "conserva las ediciones de los revisores y sus entradas nuevas" do
      run_demo_data
      lucia = demo_record("demo:account:lucia").user
      paula = demo_record("demo:person:paula").person
      draft = demo_record("demo:entry:lucia/borrador").feedback_entry
      draft.update!(context: "Texto editado por quien revisa.", signal: "neutral", dimension: "initiative")
      draft.mark_ready
      FeedbackEntry.create!(author: lucia, person: paula, occurred_on: Time.zone.today, context: "Entrada nueva de quien revisa.")
      before = demo_snapshot

      result = run_demo_data

      expect(result).to be_success
      expect(result.created).to be_empty
      expect(demo_snapshot).to eq(before)
      expect(draft.reload).to have_attributes(status: "ready", context: "Texto editado por quien revisa.")
    end

    it "no cambia contraseñas existentes aunque la variable cambie o falte" do
      run_demo_data
      lucia = demo_record("demo:account:lucia").user
      digest = lucia.password_digest
      original = demo_passwords["GROWTH_LOG_DEMO_PASSWORD_LUCIA"]

      changed = run_demo_data(variables: demo_variables(passwords: { "GROWTH_LOG_DEMO_PASSWORD_LUCIA" => generated_password }))
      removed = run_demo_data(variables: demo_variables(passwords: {}))

      expect(changed).to be_success
      expect(removed).to be_success
      expect(lucia.reload.password_digest).to eq(digest)
      expect(lucia.authenticate(original)).to eq(lucia)
    end

    it "crea solo lo que falta cuando hay elementos del conjunto sin marca" do
      run_demo_data
      entry = demo_record("demo:entry:martin/lista")
      entry.delete

      result = run_demo_data(variables: demo_variables(passwords: {}))

      expect(result).to be_success
      expect(result.created).to eq([ "demo:entry:martin/lista" ])
      expect(FeedbackEntry.count).to eq(4)
    end
  end

  describe "contraseñas iniciales" do
    it "falla sin escribir si falta la variable de una cuenta que hay que crear" do
      result = run_demo_data(variables: demo_variables(passwords: demo_passwords.except("GROWTH_LOG_DEMO_PASSWORD_MARTIN")))

      expect(result.status).to eq(:invalid)
      expect(result.errors.join).to include("GROWTH_LOG_DEMO_PASSWORD_MARTIN")
      expect(demo_counts).to eq([ 0, 0, 0, 0, 0 ])
    end

    it "falla sin escribir ni mostrar el valor si no cumple la política" do
      short = SecureRandom.alphanumeric(User::PASSWORD_MIN_LENGTH - 1)

      result = run_demo_data(variables: demo_variables(passwords: demo_passwords.merge("GROWTH_LOG_DEMO_PASSWORD_LUCIA" => short)))

      expect(result.status).to eq(:invalid)
      expect(result.errors.join).to include("GROWTH_LOG_DEMO_PASSWORD_LUCIA")
      expect(result.errors.join).not_to include(short)
      expect(demo_counts).to eq([ 0, 0, 0, 0, 0 ])
    end

    it "no incluye contraseñas ni hashes en el resultado" do
      result = run_demo_data
      text = (result.created + result.existing + result.errors).join(" ")

      demo_passwords.each_value { |password| expect(text).not_to include(password) }
      User.find_each { |user| expect(text).not_to include(user.password_digest) }
    end
  end

  describe "base dedicada" do
    it "se niega si hay una cuenta ajena, sin modificarla ni escribir nada" do
      admin = create_user(email_address: "ana.admin@example.test", name: "Ana Admin", admin: true)
      before = demo_snapshot

      result = run_demo_data

      expect(result.status).to eq(:conflict)
      expect(result.errors.join).to include("cuenta")
      expect(demo_snapshot).to eq(before)
      expect(admin.reload.admin).to be(true)
    end

    it "no adopta una cuenta con un correo del conjunto que la tarea no creó" do
      create_user(email_address: "lucia.demo@ficticio.example.test", name: "Cuenta Ajena")
      before = demo_snapshot

      result = run_demo_data

      expect(result.status).to eq(:conflict)
      expect(result.errors.join).to include("lucia.demo@ficticio.example.test")
      expect(demo_snapshot).to eq(before)
    end

    it "se niega si hay una persona ajena" do
      create_person(name: "Persona Ajena")
      before = demo_snapshot

      result = run_demo_data

      expect(result.status).to eq(:conflict)
      expect(demo_snapshot).to eq(before)
    end

    it "se niega si hay datos del conjunto de desarrollo" do
      DevelopmentSampleData.new(env: ActiveSupport::EnvironmentInquirer.new("development")).call
      before = demo_snapshot

      result = run_demo_data

      expect(result.status).to eq(:conflict)
      expect(demo_snapshot).to eq(before)
    end

    it "se niega si hay una entrada sin marca de un autor que no es una cuenta demo" do
      run_demo_data
      paula = demo_record("demo:person:paula").person
      outsider = create_user(email_address: "otra.cuenta@example.test", name: "Otra Cuenta")
      FeedbackEntry.create!(author: outsider, person: paula, occurred_on: Time.zone.today, context: "Entrada ajena.")
      before = demo_snapshot

      result = run_demo_data(variables: demo_variables(passwords: {}))

      expect(result.status).to eq(:conflict)
      expect(result.errors.join).to include("entrada")
      expect(demo_snapshot).to eq(before)
    end

    it "revierte toda la operación ante un error a mitad de la creación" do
      calls = 0
      allow(FeedbackEntry).to receive(:create!).and_wrap_original do |original, *args, **kwargs|
        calls += 1
        raise ActiveRecord::StatementInvalid, "falla simulada" if calls == 2

        original.call(*args, **kwargs)
      end

      expect { run_demo_data }.to raise_error(ActiveRecord::StatementInvalid, "falla simulada")
      expect(demo_counts).to eq([ 0, 0, 0, 0, 0 ])
    end
  end

  describe "instancia" do
    {
      "development con el indicador" => [ "development", "growth-log-entrega-2" ],
      "test con el indicador" => [ "test", "growth-log-entrega-2" ],
      "producción sin el indicador" => [ "production", nil ],
      "producción con otro valor" => [ "production", "otra-instancia" ]
    }.each do |name, (rails_env, instance)|
      it "se niega en #{name} sin consultar ni escribir la base" do
        queries = []
        callback = ->(*, payload) { queries << payload[:sql] unless payload[:name] == "SCHEMA" }

        result = ActiveSupport::Notifications.subscribed(callback, "sql.active_record") do
          run_demo_data(env: ActiveSupport::EnvironmentInquirer.new(rails_env), variables: demo_variables(instance: instance))
        end

        expect(result).to be_refused
        expect(queries).to be_empty
        expect(demo_counts).to eq([ 0, 0, 0, 0, 0 ])
      end
    end
  end
end
