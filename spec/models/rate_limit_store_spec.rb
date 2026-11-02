require "rails_helper"

RSpec.describe LoginAttemptStore do
  let(:store) { described_class.new }
  let(:now) { Time.zone.local(2026, 11, 2, 9, 0, 0) }

  it "cuenta en una ventana fija que empieza con el primer incremento" do
    travel_to(now) { expect(store.increment("k", 1, expires_in: 3.minutes)).to eq(1) }
    travel_to(now + 2.minutes) { expect(store.increment("k", 1, expires_in: 3.minutes)).to eq(2) }
    travel_to(now + 3.minutes) { expect(store.read("k")).to be_nil }
    travel_to(now + 3.minutes) { expect(store.increment("k", 1, expires_in: 3.minutes)).to eq(1) }
  end

  it "borra una clave" do
    travel_to(now) do
      store.increment("k", 1, expires_in: 3.minutes)
      store.delete("k")

      expect(store.read("k")).to be_nil
    end
  end

  it "elimina los contadores vencidos al incrementar" do
    travel_to(now) { store.increment("vieja", 1, expires_in: 1.minute) }
    travel_to(now + 2.minutes) { store.increment("nueva", 1, expires_in: 1.minute) }

    expect(LoginAttemptCounter.pluck(:key)).to eq([ "nueva" ])
  end

  describe "entre procesos" do
    self.use_transactional_tests = false

    after { LoginAttemptCounter.delete_all }

    it "comparte contadores atómicos entre procesos distintos" do
      key = "prueba-procesos:#{SecureRandom.hex(4)}"
      processes = 4
      increments = 25

      pids = Array.new(processes) do
        fork do
          # Cada proceso usa su propia conexión a PostgreSQL.
          ActiveRecord::Base.establish_connection
          increments.times { described_class.new.increment(key, 1, expires_in: 1.minute) }
          exit!(0)
        end
      end
      statuses = pids.map { |pid| Process.wait2(pid).last }

      expect(statuses).to all(be_success)
      expect(described_class.new.read(key)).to eq(processes * increments)
    end
  end
end
