# Conjunto demo de la instancia temporal en Render (GL-10, capability
# temporary-demo; P-28, P-29 y P-31).
#
# Separado del conjunto de desarrollo de GL-08, que no cambia. Escribe solo en
# producción y con GROWTH_LOG_DEMO_INSTANCE igual a INSTANCE: fuera de eso se
# niega antes de consultar la base. Solo trabaja sobre una base dedicada: si
# encuentra cuentas, personas o asignaciones sin marca demo, o entradas sin
# marca de autores que no son cuentas demo, termina sin escribir. Las
# entradas que quienes revisan crean con las cuentas demo se toleran y se
# conservan.
#
# Crea solo lo que falta y nunca modifica, adopta ni borra registros. Todo
# ocurre en una transacción con un bloqueo consultivo.
#
# La contraseña inicial de cada cuenta sale de su variable secreta y se lee
# solo al crear la cuenta (P-29): una cuenta existente nunca cambia de
# contraseña. Ni el valor ni el hash aparecen en el resultado.
class DemoData
  LOCK_KEY = 4_702_210_001
  INSTANCE_VARIABLE = "GROWTH_LOG_DEMO_INSTANCE".freeze
  INSTANCE = "growth-log-entrega-2".freeze
  DOMAIN = "ficticio.example.test".freeze

  PEOPLE = [
    { key: "demo:person:paula", name: "Paula Ejemplo", role: "Desarrolladora", team: "Equipo Faro", active: true }
  ].freeze

  ACCOUNTS = [
    { key: "demo:account:lucia", email: "lucia.demo@#{DOMAIN}", name: "Lucía Demo",
      password_variable: "GROWTH_LOG_DEMO_PASSWORD_LUCIA" },
    { key: "demo:account:martin", email: "martin.demo@#{DOMAIN}", name: "Martín Demo",
      password_variable: "GROWTH_LOG_DEMO_PASSWORD_MARTIN" }
  ].freeze

  # Días antes de la primera ejecución.
  ASSIGNMENTS = [
    { key: "demo:assignment:lucia/paula", leader: "demo:account:lucia", person: "demo:person:paula", started: 60 },
    { key: "demo:assignment:martin/paula", leader: "demo:account:martin", person: "demo:person:paula", started: 45 }
  ].freeze

  ENTRIES = [
    { key: "demo:entry:lucia/borrador", author: "demo:account:lucia", person: "demo:person:paula", days_ago: 2,
      status: "draft",
      context: "Ejemplo ficticio: en la reunión de planificación Paula propuso dividir la tarea grande en tres entregas." },
    { key: "demo:entry:lucia/lista", author: "demo:account:lucia", person: "demo:person:paula", days_ago: 9,
      status: "ready", signal: "positive", dimension: "teamwork",
      context: "Ejemplo ficticio: Paula acompañó a una compañera nueva en su primera revisión de código.",
      evidence: "La revisión se cerró el mismo día, con comentarios claros." },
    { key: "demo:entry:martin/lista", author: "demo:account:martin", person: "demo:person:paula", days_ago: 6,
      status: "ready", signal: "improvement", dimension: "communication",
      context: "Ejemplo ficticio: el resumen semanal de Paula llegó sin los riesgos abiertos del proyecto." }
  ].freeze

  KEYS = (PEOPLE + ACCOUNTS + ASSIGNMENTS + ENTRIES).map { |item| item[:key] }.freeze

  Result = Data.define(:status, :created, :existing, :errors) do
    def success? = status == :created
    def refused? = status == :refused
  end

  def initialize(env: Rails.env, variables: ENV)
    @env = env
    @variables = variables
  end

  def call
    # Antes de cualquier consulta: fuera de la instancia demo no se toca la base.
    return result(:refused) unless demo_instance?

    created = []
    existing = []
    errors = []
    status = nil

    ActiveRecord::Base.transaction do
      ActiveRecord::Base.connection.execute("SELECT pg_advisory_xact_lock(#{LOCK_KEY})")
      marks = DemoDataRecord.all.index_by(&:key)

      errors = foreign_records(marks)
      next status = :conflict if errors.any?

      errors = invalid_passwords(marks)
      next status = :invalid if errors.any?

      create_people(marks, created, existing)
      create_accounts(marks, created, existing)
      create_assignments(marks, created, existing)
      create_entries(marks, created, existing)
      status = :created
    end

    status == :created ? Result.new(status: :created, created: created, existing: existing, errors: []) : result(status, errors)
  end

  private
    def result(status, errors = [])
      Result.new(status: status, created: [], existing: [], errors: errors)
    end

    def demo_instance?
      @env.production? && @variables[INSTANCE_VARIABLE] == INSTANCE
    end

    # Revisión previa a cualquier escritura: la base debe ser la de la demo.
    def foreign_records(marks)
      demo_user_ids = marks.values.filter_map(&:user_id)
      demo_person_ids = marks.values.filter_map(&:person_id)
      demo_assignment_ids = marks.values.filter_map(&:assignment_id)
      demo_entry_ids = marks.values.filter_map(&:feedback_entry_id)

      errors = []
      ACCOUNTS.each do |account|
        next if marks.key?(account[:key])
        next unless User.exists?(email_address: account[:email])

        errors << "#{account[:key]}: ya existe una cuenta con #{account[:email]} que la tarea no creó"
      end

      foreign_users = User.where.not(id: demo_user_ids).count
      errors << "la base tiene #{foreign_users} cuenta(s) que no son del conjunto demo" if foreign_users.positive?

      foreign_people = Person.where.not(id: demo_person_ids).count
      errors << "la base tiene #{foreign_people} persona(s) que no son del conjunto demo" if foreign_people.positive?

      foreign_assignments = Assignment.where.not(id: demo_assignment_ids).count
      errors << "la base tiene #{foreign_assignments} asignación(es) que no son del conjunto demo" if foreign_assignments.positive?

      foreign_entries = FeedbackEntry.where.not(id: demo_entry_ids).where.not(author_id: demo_user_ids).count
      errors << "la base tiene #{foreign_entries} entrada(s) de autores que no son cuentas demo" if foreign_entries.positive?

      errors
    end

    # Solo para las cuentas que hay que crear; nunca se informa el valor.
    def invalid_passwords(marks)
      ACCOUNTS.filter_map do |account|
        next if marks.key?(account[:key])

        password = @variables[account[:password_variable]].to_s
        if password.empty?
          "#{account[:key]}: falta la variable #{account[:password_variable]} con la contraseña inicial"
        elsif password.length < User::PASSWORD_MIN_LENGTH || password.bytesize > 72
          "#{account[:key]}: la contraseña de #{account[:password_variable]} no cumple la política " \
            "(entre #{User::PASSWORD_MIN_LENGTH} caracteres y 72 bytes)"
        end
      end
    end

    def create_people(marks, created, existing)
      PEOPLE.each do |person|
        next existing << person[:key] if marks.key?(person[:key])

        record = Person.create!(person.slice(:name, :role, :team, :active))
        marks[person[:key]] = DemoDataRecord.create!(key: person[:key], person: record)
        created << person[:key]
      end
    end

    def create_accounts(marks, created, existing)
      ACCOUNTS.each do |account|
        next existing << account[:key] if marks.key?(account[:key])

        record = User.create!(
          email_address: account[:email],
          name: account[:name],
          password: @variables.fetch(account[:password_variable]),
          admin: false
        )
        marks[account[:key]] = DemoDataRecord.create!(key: account[:key], user: record)
        created << account[:key]
      end
    end

    def create_assignments(marks, created, existing)
      ASSIGNMENTS.each do |assignment|
        next existing << assignment[:key] if marks.key?(assignment[:key])

        record = Assignment.create!(
          leader: marks.fetch(assignment[:leader]).user,
          person: marks.fetch(assignment[:person]).person,
          started_at: assignment[:started].days.ago
        )
        marks[assignment[:key]] = DemoDataRecord.create!(key: assignment[:key], assignment: record)
        created << assignment[:key]
      end
    end

    def create_entries(marks, created, existing)
      ENTRIES.each do |entry|
        next existing << entry[:key] if marks.key?(entry[:key])

        record = FeedbackEntry.create!(
          author: marks.fetch(entry[:author]).user,
          person: marks.fetch(entry[:person]).person,
          occurred_on: Time.zone.today - entry[:days_ago],
          **entry.slice(:status, :signal, :dimension, :context, :evidence)
        )
        marks[entry[:key]] = DemoDataRecord.create!(key: entry[:key], feedback_entry: record)
        created << entry[:key]
      end
    end
end
