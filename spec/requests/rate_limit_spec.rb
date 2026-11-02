require "rails_helper"

RSpec.describe "Limitación de intentos de inicio de sesión", type: :request do
  let(:too_many) { "Demasiados intentos. Probá de nuevo en unos minutos." }
  let!(:user) { create_user(email_address: "luis.lider@example.test") }
  let(:start) { Time.zone.local(2026, 11, 2, 9, 0, 0) }

  def attempt(email:, password:, ip: "203.0.113.10")
    post session_path, params: { email_address: email, password: password }, env: { "REMOTE_ADDR" => ip }
    response.status
  end

  def alert_text
    Nokogiri::HTML(response.body).at_css("[role=alert]")&.text&.strip
  end

  describe "por dirección IP" do
    it "rechaza el undécimo intento en 3 minutos aunque las credenciales sean válidas" do
      travel_to(start) do
        10.times { |i| attempt(email: "desconocido#{i}@example.test", password: generated_password) }

        expect(attempt(email: user.email_address, password: user.password)).to eq(429)
        expect(alert_text).to eq(too_many)
        expect(Session.count).to eq(0)
      end
    end

    it "cuenta también los intentos exitosos" do
      travel_to(start) do
        10.times do
          expect(attempt(email: user.email_address, password: user.password)).to eq(303)
          delete session_path
        end

        expect(attempt(email: user.email_address, password: user.password)).to eq(429)
      end
    end

    it "vuelve a permitir intentos al vencer la ventana de 3 minutos" do
      travel_to(start) do
        10.times { |i| attempt(email: "desconocido#{i}@example.test", password: generated_password) }
        expect(attempt(email: user.email_address, password: user.password)).to eq(429)
      end

      travel_to(start + 3.minutes + 1.second) do
        expect(attempt(email: user.email_address, password: user.password)).to eq(303)
      end
    end

    it "no afecta a otra dirección IP" do
      travel_to(start) do
        10.times { |i| attempt(email: "desconocido#{i}@example.test", password: generated_password) }

        expect(attempt(email: user.email_address, password: user.password, ip: "198.51.100.20")).to eq(303)
      end
    end
  end

  describe "por correo" do
    def fail_from_distinct_ips(count, email: user.email_address)
      count.times { |i| attempt(email: email, password: generated_password, ip: "198.51.100.#{i + 1}") }
    end

    it "rechaza el sexto intento tras cinco fallos desde IP distintas aunque las credenciales sean válidas" do
      travel_to(start) do
        fail_from_distinct_ips(5)

        expect(attempt(email: user.email_address, password: user.password, ip: "203.0.113.99")).to eq(429)
        expect(alert_text).to eq(too_many)
        expect(Session.count).to eq(0)
      end
    end

    it "cuenta juntas las variantes de mayúsculas y espacios" do
      travel_to(start) do
        [ "LUIS.LIDER@example.test", " luis.lider@EXAMPLE.test ", "Luis.Lider@Example.Test", "luis.lider@example.test ", "LUIS.lider@example.TEST" ].each_with_index do |variant, i|
          attempt(email: variant, password: generated_password, ip: "198.51.100.#{i + 1}")
        end

        expect(attempt(email: user.email_address, password: user.password, ip: "203.0.113.99")).to eq(429)
      end
    end

    it "reinicia el conteo tras un inicio de sesión exitoso" do
      travel_to(start) do
        fail_from_distinct_ips(4)
        expect(attempt(email: user.email_address, password: user.password, ip: "203.0.113.50")).to eq(303)
        delete session_path

        fail_from_distinct_ips(4)
        expect(attempt(email: user.email_address, password: user.password, ip: "203.0.113.51")).to eq(303)
      end
    end

    it "vuelve a permitir intentos al vencer la ventana de 15 minutos" do
      travel_to(start) { fail_from_distinct_ips(5) }

      travel_to(start + 15.minutes + 1.second) do
        expect(attempt(email: user.email_address, password: user.password, ip: "203.0.113.99")).to eq(303)
      end
    end

    it "no afecta a otro correo" do
      other = create_user(email_address: "ana.admin@example.test", name: "Ana Admin")

      travel_to(start) do
        fail_from_distinct_ips(5)

        expect(attempt(email: other.email_address, password: other.password, ip: "203.0.113.99")).to eq(303)
      end
    end
  end

  it "guarda los contadores sin el correo ni la IP en claro" do
    travel_to(start) do
      attempt(email: user.email_address, password: generated_password, ip: "203.0.113.77")
    end

    keys = LoginAttemptCounter.pluck(:key)
    expect(keys.size).to eq(2) # uno por IP y uno por correo

    keys.each do |key|
      [ "luis.lider", "example.test", "203.0.113.77" ].each do |fragment|
        expect(key).not_to include(fragment)
      end
    end
  end
end
