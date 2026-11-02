require "rails_helper"
require "rake"

RSpec.describe "Administrador inicial" do
  def run_command(input:, env: {})
    output = StringIO.new
    status = InitialAdministratorCommand.new(input: StringIO.new(input), output: output, env: env).call
    [ status, output.string ]
  end

  let(:env) { { "EMAIL" => "Ana.Admin@Example.TEST", "NOMBRE" => "Ana Admin" } }

  describe "comando" do
    it "crea una cuenta administradora activa que puede iniciar sesión" do
      password = generated_password

      status, output = run_command(input: "#{password}\n#{password}\n", env: env)

      expect(status).to eq(0)
      admin = User.find_by!(email_address: "ana.admin@example.test")
      expect(admin).to have_attributes(admin: true, name: "Ana Admin")
      expect(admin).to be_active
      expect(User.authenticate_by(email_address: "ana.admin@example.test", password: password)).to eq(admin)
      expect(output).not_to include(password)
    end

    it "pide correo y nombre cuando no vienen en el entorno" do
      password = generated_password

      status, output = run_command(input: "ana.admin@example.test\nAna Admin\n#{password}\n#{password}\n")

      expect(status).to eq(0)
      expect(User.where(admin: true).pluck(:email_address)).to eq([ "ana.admin@example.test" ])
      expect(output).not_to include(password)
    end

    it "no crea la cuenta si las contraseñas no coinciden" do
      first = generated_password
      second = generated_password

      status, output = run_command(input: "#{first}\n#{second}\n", env: env)

      expect(status).to eq(1)
      expect(output).to include("Las contraseñas no coinciden.")
      expect(User.count).to eq(0)
      expect(output).not_to include(first)
      expect(output).not_to include(second)
    end

    it "no crea la cuenta si la contraseña no cumple la política" do
      short = "a" * 14

      status, output = run_command(input: "#{short}\n#{short}\n", env: env)

      expect(status).to eq(1)
      expect(output).to match(/15/)
      expect(User.count).to eq(0)
      expect(output).not_to include(short)
    end

    it "no lee la contraseña de variables de entorno" do
      password = generated_password

      status, _output = run_command(input: "", env: env.merge("PASSWORD" => password, "CONTRASENA" => password))

      expect(status).to eq(1)
      expect(User.count).to eq(0)
    end

    it "se niega a repetir la creación si ya hay un administrador activo, sin modificar cuentas" do
      existing = create_user(email_address: "eva.admin@example.test", name: "Eva Admin", admin: true)
      digest_before = existing.password_digest
      password = generated_password

      status, output = run_command(input: "#{password}\n#{password}\n", env: env)

      expect(status).to eq(1)
      expect(output).to include("Ya existe un administrador activo.")
      expect(User.count).to eq(1)
      expect(existing.reload.password_digest).to eq(digest_before)
    end
  end

  describe "tarea de Rake" do
    before(:all) do
      Rails.application.load_tasks unless Rake::Task.task_defined?("growth_log:crear_administrador")
    end

    it "está declarada y usa el comando" do
      password = generated_password
      task = Rake::Task["growth_log:crear_administrador"]
      task.reenable

      original_stdin = $stdin
      $stdin = StringIO.new("#{password}\n#{password}\n")
      begin
        expect { task.invoke }.to output(/Administrador creado/).to_stdout
          .and change { User.where(admin: true).count }.from(0).to(1)
      ensure
        $stdin = original_stdin
      end
    end

    around do |example|
      original = ENV.to_h.slice("EMAIL", "NOMBRE")
      ENV["EMAIL"] = "ana.admin@example.test"
      ENV["NOMBRE"] = "Ana Admin"
      example.run
    ensure
      %w[EMAIL NOMBRE].each { |k| original.key?(k) ? ENV[k] = original[k] : ENV.delete(k) }
    end
  end

  describe "concurrencia" do
    self.use_transactional_tests = false

    after do
      Session.delete_all
      User.delete_all
    end

    def attempt(email)
      password = generated_password
      ActiveRecord::Base.connection_pool.with_connection do
        InitialAdministrator.create(email_address: email, name: "Admin", password: password, password_confirmation: password)
      end
    end

    it "espera el bloqueo de otra creación en curso y después se niega" do
      lock_held = Queue.new
      release = Queue.new

      holder = Thread.new do
        ActiveRecord::Base.connection_pool.with_connection do
          ActiveRecord::Base.transaction do
            InitialAdministrator.acquire_lock!
            lock_held << true
            release.pop
            User.create!(email_address: "eva.admin@example.test", name: "Eva Admin", password: generated_password, admin: true)
          end
        end
      end

      # Tiempos máximos: si el hilo que bloquea falla, la prueba falla en vez de colgarse.
      expect(Timeout.timeout(10) { lock_held.pop }).to be(true)
      contender = Thread.new { attempt("ana.admin@example.test") }

      sleep 0.5
      expect(contender).to be_alive # bloqueado esperando el bloqueo consultivo

      release << true
      expect(holder.join(10)).to be_truthy
      expect(contender.join(10)).to be_truthy
      result = contender.value

      expect(result).not_to be_success
      expect(result.errors).to include("Ya existe un administrador activo.")
      expect(User.where(admin: true).pluck(:email_address)).to eq([ "eva.admin@example.test" ])
    end

    it "dos ejecuciones simultáneas crean un solo administrador" do
      start = Queue.new
      threads = %w[ana.admin@example.test eva.admin@example.test].map do |email|
        Thread.new do
          start.pop
          attempt(email)
        end
      end
      2.times { start << true }
      threads.each { |t| expect(t.join(10)).to be_truthy }
      results = threads.map(&:value)

      expect(results.count(&:success?)).to eq(1)
      expect(User.where(admin: true).count).to eq(1)
    end
  end
end
