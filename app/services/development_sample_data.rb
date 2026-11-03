# Conjunto ficticio de desarrollo (GL-08, P-6, P-13, P-14).
#
# Crea solo lo que falta del conjunto y nunca modifica, reactiva ni borra
# registros existentes. Reconoce como propios únicamente los registros que
# marcó en sample_data_records. Todo ocurre en una transacción con un
# bloqueo consultivo: un conflicto o un error revierte la operación completa.
#
# Cada cuenta se crea con una contraseña aleatoria de 48 caracteres que no
# se guarda ni se muestra. Eso no la deshabilita: queda activa (salvo la
# definida como desactivada) y solo admitiría esa contraseña, que nadie
# conoce. Pablo la reemplaza con growth_log:contrasena_ficticia.
class DevelopmentSampleData
  LOCK_KEY = 4_702_208_001
  DOMAIN = "ficticio.example.test".freeze

  ACCOUNTS = [
    { key: "account:elena", email: "elena.boceto@#{DOMAIN}", name: "Elena Boceto", active: true },
    { key: "account:tomas", email: "tomas.borrador@#{DOMAIN}", name: "Tomás Borrador", active: true },
    { key: "account:ines", email: "ines.muestra@#{DOMAIN}", name: "Inés Muestra", active: true },
    { key: "account:raul", email: "raul.pasado@#{DOMAIN}", name: "Raúl Pasado", active: true },
    { key: "account:delia", email: "delia.inactiva@#{DOMAIN}", name: "Delia Inactiva", active: false }
  ].freeze

  PEOPLE = [
    { key: "person:ada", name: "Ada Ejemplo", role: "Desarrolladora", team: "Equipo Faro", active: true },
    { key: "person:bruno", name: "Bruno Ejemplo", role: "Analista", team: "Equipo Faro", active: true },
    { key: "person:carla", name: "Carla Ejemplo", role: "Diseñadora", team: "Equipo Brújula", active: true },
    { key: "person:dario", name: "Darío Ejemplo", role: "Desarrollador", team: "Equipo Brújula", active: false },
    { key: "person:eva", name: "Eva Ejemplo", role: "QA", team: "Equipo Faro", active: true }
  ].freeze

  # Días antes de la primera ejecución; ended: nil indica asignación activa.
  ASSIGNMENTS = [
    { key: "assignment:elena/ada", leader: "account:elena", person: "person:ada", started: 60, ended: nil },
    { key: "assignment:tomas/ada", leader: "account:tomas", person: "person:ada", started: 45, ended: nil },
    { key: "assignment:elena/bruno", leader: "account:elena", person: "person:bruno", started: 60, ended: nil },
    { key: "assignment:tomas/carla", leader: "account:tomas", person: "person:carla", started: 45, ended: nil },
    { key: "assignment:elena/dario", leader: "account:elena", person: "person:dario", started: 30, ended: nil },
    { key: "assignment:raul/bruno", leader: "account:raul", person: "person:bruno", started: 90, ended: 20 },
    { key: "assignment:delia/ada", leader: "account:delia", person: "person:ada", started: 90, ended: nil }
  ].freeze

  Result = Data.define(:status, :created, :existing, :conflicts) do
    def success? = status == :created
    def refused? = status == :refused
  end

  Conflict = Class.new(StandardError)

  def initialize(env: Rails.env, password_generator: -> { SecureRandom.base58(48) })
    @env = env
    @password_generator = password_generator
  end

  def call
    # Antes de cualquier consulta: fuera de desarrollo no se toca la base.
    return Result.new(status: :refused, created: [], existing: [], conflicts: []) unless @env.development?

    created = []
    existing = []
    conflicts = []

    ActiveRecord::Base.transaction do
      ActiveRecord::Base.connection.execute("SELECT pg_advisory_xact_lock(#{LOCK_KEY})")
      marks = SampleDataRecord.all.index_by(&:key)

      conflicts = find_conflicts(marks)
      raise Conflict if conflicts.any?

      PEOPLE.each do |person|
        next existing << person[:key] if marks.key?(person[:key])

        record = Person.create!(person.slice(:name, :role, :team, :active))
        marks[person[:key]] = SampleDataRecord.create!(key: person[:key], person: record)
        created << person[:key]
      end

      ACCOUNTS.each do |account|
        next existing << account[:key] if marks.key?(account[:key])

        record = User.create!(
          email_address: account[:email],
          name: account[:name],
          password: @password_generator.call,
          admin: false,
          deactivated_at: (account[:active] ? nil : Time.current)
        )
        marks[account[:key]] = SampleDataRecord.create!(key: account[:key], user: record)
        created << account[:key]
      end

      ASSIGNMENTS.each do |assignment|
        next existing << assignment[:key] if marks.key?(assignment[:key])

        record = Assignment.create!(
          leader: marks.fetch(assignment[:leader]).user,
          person: marks.fetch(assignment[:person]).person,
          started_at: assignment[:started].days.ago,
          ended_at: assignment[:ended]&.days&.ago
        )
        marks[assignment[:key]] = SampleDataRecord.create!(key: assignment[:key], assignment: record)
        created << assignment[:key]
      end
    end

    Result.new(status: :created, created: created, existing: existing, conflicts: [])
  rescue Conflict
    Result.new(status: :conflict, created: [], existing: [], conflicts: conflicts)
  end

  private
    # Revisión previa a cualquier escritura: nada ajeno se adopta.
    def find_conflicts(marks)
      account_conflicts = ACCOUNTS.filter_map do |account|
        next if marks.key?(account[:key])
        next unless User.exists?(email_address: account[:email])

        "#{account[:key]}: ya existe una cuenta con #{account[:email]} que la tarea no creó"
      end

      assignment_conflicts = ASSIGNMENTS.filter_map do |assignment|
        next if marks.key?(assignment[:key])

        leader = marks[assignment[:leader]]&.user
        person = marks[assignment[:person]]&.person
        next unless leader && person
        next unless Assignment.active.exists?(leader: leader, person: person)

        "#{assignment[:key]}: ya existe una asignación activa de ese par que la tarea no creó"
      end

      account_conflicts + assignment_conflicts
    end
end
