# Ayudas de prueba para GL-10. El entorno y las variables se inyectan para
# ejercitar la tarea demo dentro de la base de test; la tarea real solo
# escribe en producción con el indicador de la instancia demo. Las
# contraseñas se generan en cada prueba y nunca se imprimen.
module DemoDataHelpers
  def production_env
    ActiveSupport::EnvironmentInquirer.new("production")
  end

  def demo_passwords
    @demo_passwords ||= {
      "GROWTH_LOG_DEMO_PASSWORD_LUCIA" => generated_password,
      "GROWTH_LOG_DEMO_PASSWORD_MARTIN" => generated_password
    }
  end

  def demo_variables(passwords: demo_passwords, instance: "growth-log-entrega-2")
    variables = passwords.dup
    variables["GROWTH_LOG_DEMO_INSTANCE"] = instance unless instance.nil?
    variables
  end

  def run_demo_data(env: production_env, variables: demo_variables)
    DemoData.new(env: env, variables: variables).call
  end

  def demo_record(key)
    DemoDataRecord.find_by!(key: key)
  end

  def demo_snapshot
    {
      users: User.order(:id).map { |u| u.attributes.except("updated_at").merge("updated_at" => u.updated_at.to_f) },
      people: Person.order(:id).map(&:attributes),
      assignments: Assignment.order(:id).map(&:attributes),
      entries: FeedbackEntry.order(:id).map { |e| e.attributes.except("updated_at").merge("updated_at" => e.updated_at.to_f) },
      records: DemoDataRecord.order(:id).map(&:attributes)
    }
  end

  def demo_counts
    [ User.count, Person.count, Assignment.count, FeedbackEntry.count, DemoDataRecord.count ]
  end
end

RSpec.configure do |config|
  config.include DemoDataHelpers
end
