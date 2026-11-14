require "rails_helper"

# Fecha de hoy en la zona de la instancia (GL-06, P-23) y texto del feedback
# fuera de los logs (spec feedback-entries, F12; RN-5). El requisito de logs
# cubre la petición y las consultas: si el log de consultas mostrara el
# texto, el requisito no se relaja.
RSpec.describe "Fecha de la captura y logs de las entradas", type: :request do
  let!(:leader) { create_user(email_address: "luis.lider@example.test", name: "Luis Líder") }
  let!(:person) { create_person(name: "Ada Ejemplo") }

  before { assign(leader, person) }

  describe "fecha de hoy (P-23)" do
    it "la aplicación usa la zona America/Argentina/Buenos_Aires" do
      expect(Time.zone.tzinfo.identifier).to eq("America/Argentina/Buenos_Aires")
    end

    it "una captura a las 22:30 de Buenos Aires, cuando en UTC ya es el día siguiente, lleva la fecha de Buenos Aires" do
      instant = Time.utc(2026, 11, 13, 1, 30) # 12/11/2026 22:30 en Buenos Aires (UTC-3)

      travel_to(instant) do
        sign_in_as(leader)
        post person_feedback_entries_path(person), params: { feedback_entry: { context: "Captura nocturna" } }
      end

      expect(FeedbackEntry.order(:id).last.occurred_on).to eq(Date.new(2026, 11, 12))
    end
  end

  describe "texto fuera de los logs (F12)" do
    around do |example|
      originals = [ ActionController::Base.logger, ActiveRecord::Base.logger ]
      @request_log = StringIO.new
      @query_log = StringIO.new
      ActionController::Base.logger = ActiveSupport::Logger.new(@request_log).tap { |logger| logger.level = :debug }
      ActiveRecord::Base.logger = ActiveSupport::Logger.new(@query_log).tap { |logger| logger.level = :debug }
      example.run
    ensure
      ActionController::Base.logger, ActiveRecord::Base.logger = originals
    end

    def secret(label) = "#{label}-#{SecureRandom.hex(6)}"

    it "al guardar una captura, ni el log de la petición ni el de las consultas tienen el texto" do
      context = secret("Contexto")
      sign_in_as(leader)

      post person_feedback_entries_path(person), params: { feedback_entry: { context: context } }

      expect(FeedbackEntry.order(:id).last.context).to eq(context)
      expect(@request_log.string).to include("[FILTERED]")
      expect(@request_log.string).not_to include(context)
      expect(@query_log.string).to match(/INSERT INTO "feedback_entries"/)
      expect(@query_log.string).not_to include(context)
    end

    it "al completar una entrada, ningún log tiene la evidencia, el impacto ni el contexto" do
      entry = FeedbackEntry.create!(author: leader, person: person, occurred_on: Date.new(2026, 11, 12), context: "Inicial")
      values = { context: secret("Contexto"), evidence: secret("Evidencia"), impact: secret("Impacto") }
      sign_in_as(leader)

      patch feedback_entry_path(entry), params: { feedback_entry: values }

      expect(entry.reload).to have_attributes(values)
      expect(@query_log.string).to match(/UPDATE "feedback_entries"/)
      values.each_value do |value|
        expect(@request_log.string).not_to include(value)
        expect(@query_log.string).not_to include(value)
      end
    end
  end
end
