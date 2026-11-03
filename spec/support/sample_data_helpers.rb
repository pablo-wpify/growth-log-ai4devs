# Ayudas de prueba para GL-08. El entorno se inyecta para ejercitar la
# creación dentro de la base de test; la tarea real solo corre en desarrollo.
module SampleDataHelpers
  def development_env
    ActiveSupport::EnvironmentInquirer.new("development")
  end

  def run_sample_data(env: development_env)
    DevelopmentSampleData.new(env: env).call
  end

  def sample_user(key)
    SampleDataRecord.find_by!(key: key).user
  end

  def sample_person(key)
    SampleDataRecord.find_by!(key: key).person
  end

  def sample_assignment(key)
    SampleDataRecord.find_by!(key: key).assignment
  end

  def sample_data_snapshot
    {
      users: User.order(:id).map { |u| u.attributes.except("updated_at").merge("updated_at" => u.updated_at.to_f) },
      people: Person.order(:id).map(&:attributes),
      assignments: Assignment.order(:id).map(&:attributes),
      records: SampleDataRecord.order(:id).map(&:attributes)
    }
  end
end

RSpec.configure do |config|
  config.include SampleDataHelpers
end
