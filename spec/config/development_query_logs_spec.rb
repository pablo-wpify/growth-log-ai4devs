require "rails_helper"
require "json"
require "open3"
require "tmpdir"

# Regresión de F12 en desarrollo (GL-06). Con
# `config.active_record.query_log_tags_enabled`, Active Record desactiva las
# sentencias preparadas y escribe los valores dentro del SQL del log, donde
# `filter_parameters` no los alcanza: el texto del feedback aparecía en el
# log de consultas de desarrollo (F17, 13/11/2026).
#
# Las pruebas de logs de test no lo detectan, porque en test las sentencias
# preparadas están activas. Esta prueba arranca un proceso con
# RAILS_ENV=development, que carga la configuración y el railtie de
# desarrollo, y lo conecta a la base de **test**: nunca usa la base de
# desarrollo. Inserta un texto ficticio dentro de una transacción que se
# revierte y devuelve lo que quedó en el log de consultas.
RSpec.describe "Log de consultas de desarrollo (F12)" do
  PROBE = <<~'RUBY'.freeze
    require "json"
    test_config = ActiveRecord::Base.configurations.configs_for(env_name: "test").first
    ActiveRecord::Base.establish_connection(test_config)
    log = StringIO.new
    ActiveRecord::Base.logger = ActiveSupport::Logger.new(log).tap { |logger| logger.level = :debug }
    secret = ENV.fetch("F12_PROBE_TEXT")
    ActiveRecord::Base.transaction do
      author = User.create!(email_address: "sonda.f12@example.test", name: "Sonda F12", password: SecureRandom.alphanumeric(24))
      person = Person.create!(name: "Persona Sonda F12")
      entry = FeedbackEntry.create!(author: author, person: person, occurred_on: Date.new(2026, 11, 12), context: secret)
      entry.update!(evidence: secret, impact: secret)
      raise ActiveRecord::Rollback
    end
    sql = log.string.gsub(/\e\[[\d;]*m/, "")
    puts "F12_RESULT=" + JSON.generate(
      env: Rails.env,
      database: ActiveRecord::Base.connection_db_config.database,
      query_log_tags_enabled: Rails.application.config.active_record.query_log_tags_enabled,
      prepared_statements: ActiveRecord::Base.connection.prepared_statements,
      logged_insert: sql.include?('INSERT INTO "feedback_entries"'),
      logged_update: sql.include?('UPDATE "feedback_entries"'),
      secret_in_log: sql.include?(secret),
      filtered_in_log: sql.include?("[FILTERED]")
    )
  RUBY

  let(:secret) { "F12-sonda-#{SecureRandom.hex(8)}" }

  def run_probe
    Dir.mktmpdir do |dir|
      script = File.join(dir, "f12_probe.rb")
      File.write(script, PROBE)
      output, status = Open3.capture2e(
        { "RAILS_ENV" => "development", "F12_PROBE_TEXT" => secret },
        Rails.root.join("bin/rails").to_s, "runner", script,
        chdir: Rails.root.to_s
      )
      line = output.lines.find { |text| text.start_with?("F12_RESULT=") }
      expect(status).to be_success, "el proceso de desarrollo terminó con #{status.exitstatus}"
      expect(line).to be_present, "el proceso de desarrollo no devolvió resultado"
      JSON.parse(line.delete_prefix("F12_RESULT="), symbolize_names: true)
    end
  end

  it "desarrollo no activa las etiquetas de consulta, que desactivarían las sentencias preparadas" do
    result = run_probe

    expect(result).to include(env: "development", database: "growth_log_test")
    expect(result[:query_log_tags_enabled]).to be_falsey
    expect(result[:prepared_statements]).to be(true)
  end

  it "con la configuración de desarrollo, el texto ficticio no aparece en el log de consultas" do
    result = run_probe

    expect(result).to include(logged_insert: true, logged_update: true)
    expect(result[:secret_in_log]).to be(false)
    expect(result[:filtered_in_log]).to be(true)
  end
end
