require "rails_helper"

# Límite por correo bajo concurrencia (GL-02, requisito «Limitación de intentos
# fallidos por correo»: como máximo 5 por ventana, sin evaluar credenciales al
# llegar al límite). Las peticiones se ejecutan en hilos contra la aplicación
# real, con la evaluación de credenciales retenida en una barrera: así todas
# están en vuelo a la vez y la prueba no depende del azar.
RSpec.describe "Límite por correo con peticiones simultáneas" do
  self.use_transactional_tests = false

  let(:email) { "luis.lider@example.test" }
  let(:requests) { 8 }

  # Las 8 peticiones retienen su conexión mientras esperan en la barrera: el
  # pool de test (5) no alcanza, así que esta prueba usa uno más grande y
  # restablece el original al terminar.
  around do |example|
    original = ActiveRecord::Base.connection_db_config
    ActiveRecord::Base.establish_connection(original.configuration_hash.merge(max_connections: requests + 4))
    example.run
  ensure
    ActiveRecord::Base.establish_connection(original)
  end

  before { create_user(email_address: email) }

  after do
    LoginAttemptCounter.delete_all
    Session.delete_all
    User.delete_all
  end

  def post_login(ip)
    env = Rack::MockRequest.env_for(
      "/session",
      method: "POST",
      params: { email_address: email, password: generated_password },
      "REMOTE_ADDR" => ip,
      "HTTP_HOST" => "www.example.com"
    )
    status, _headers, body = Rails.application.call(env)
    body.close if body.respond_to?(:close)
    status
  end

  it "evalúa credenciales como máximo 5 veces y responde 429 al resto sin evaluarlas" do
    evaluated = Queue.new
    gate = Queue.new
    original = User.method(:authenticate_by)

    allow(User).to receive(:authenticate_by) do |*args, **kwargs|
      evaluated << true
      gate.pop # retiene la evaluación hasta que todas las peticiones estén en vuelo
      original.call(*args, **kwargs)
    end

    statuses = Queue.new
    threads = Array.new(requests) do |i|
      Thread.new do
        Rails.application.executor.wrap do
          statuses << post_login("198.51.100.#{i + 1}")
        end
      end
    end

    # Esperar a que cada petición haya llegado a la evaluación o haya terminado.
    Timeout.timeout(20) { sleep 0.05 until evaluated.size + statuses.size == requests }
    in_flight = evaluated.size

    requests.times { gate << true }
    threads.each { |thread| expect(thread.join(20)).to be_truthy }
    results = Array.new(statuses.size) { statuses.pop }

    expect(in_flight).to eq(5)
    expect(results.tally).to eq(422 => 5, 429 => 3)
  end
end
