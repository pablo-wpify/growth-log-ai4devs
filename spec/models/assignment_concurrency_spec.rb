require "rails_helper"

# Unicidad de la asignación activa por par con dos inserciones simultáneas
# (GL-03, P-8). Determinista: la primera transacción inserta y queda
# abierta; la segunda inserta el mismo par y la prueba espera a ver en
# PostgreSQL que está bloqueada por esa fila antes de confirmar la primera.
RSpec.describe "Asignación activa por par con inserciones simultáneas" do
  self.use_transactional_tests = false

  after do
    Assignment.delete_all
    Person.delete_all
    Session.delete_all
    User.delete_all
  end

  def waiting_on_lock?(pid)
    ActiveRecord::Base.connection_pool.with_connection do |connection|
      connection.select_value(
        "SELECT wait_event_type = 'Lock' FROM pg_stat_activity WHERE pid = #{Integer(pid)}"
      )
    end
  end

  it "rechaza la segunda inserción y queda una sola asignación activa" do
    leader = create_user
    person = create_person
    inserted = Queue.new
    release = Queue.new
    second_pid = Queue.new

    first = Thread.new do
      ActiveRecord::Base.connection_pool.with_connection do
        Assignment.transaction do
          Assignment.create!(leader: leader, person: person, started_at: Time.current)
          inserted << true
          release.pop
        end
      end
    end

    second = nil
    begin
      expect(Timeout.timeout(10) { inserted.pop }).to be(true)

      second = Thread.new do
        ActiveRecord::Base.connection_pool.with_connection do |connection|
          second_pid << connection.select_value("SELECT pg_backend_pid()")
          Assignment.create!(leader: leader, person: person, started_at: Time.current)
          :created
        rescue ActiveRecord::RecordNotUnique
          :rejected
        end
      end

      pid = Timeout.timeout(10) { second_pid.pop }
      # La segunda inserción tiene que esperar la fila sin confirmar de la
      # primera. Sin el índice único no espera: termina antes y la prueba
      # falla aquí en lugar de colgarse.
      waited = false
      Timeout.timeout(10) do
        until waited || !second.alive?
          waited = waiting_on_lock?(pid)
          sleep 0.05 unless waited
        end
      end
      expect(waited).to be(true), "la segunda inserción no esperó a la primera"
    ensure
      # Siempre se libera la primera transacción, también si algo falla.
      release << true
      expect(first.join(10)).to be_truthy
      expect(second.join(10)).to be_truthy if second
    end

    expect(second.value).to eq(:rejected)
    expect(Assignment.active.where(leader: leader, person: person).count).to eq(1)
  end
end
