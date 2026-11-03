require "rails_helper"

# Dos ejecuciones simultáneas del conjunto ficticio (GL-08). Determinista:
# la primera crea el conjunto y retiene su transacción; la segunda tiene que
# quedar esperando el bloqueo consultivo, comprobado en PostgreSQL, antes de
# que la primera confirme. Siempre se libera la primera transacción.
RSpec.describe "Conjunto ficticio con ejecuciones simultáneas" do
  self.use_transactional_tests = false

  after do
    SampleDataRecord.delete_all
    Assignment.delete_all
    Session.delete_all
    User.delete_all
    Person.delete_all
  end

  def waiting_on_lock?(pid)
    ActiveRecord::Base.connection_pool.with_connection do |connection|
      connection.select_value("SELECT wait_event_type = 'Lock' FROM pg_stat_activity WHERE pid = #{Integer(pid)}")
    end
  end

  it "deja un solo conjunto" do
    created = Queue.new
    release = Queue.new
    second_pid = Queue.new
    first_result = nil

    first = Thread.new do
      ActiveRecord::Base.connection_pool.with_connection do
        ActiveRecord::Base.transaction do
          first_result = run_sample_data
          created << true
          release.pop
        end
      end
    end

    second = nil
    begin
      expect(Timeout.timeout(10) { created.pop }).to be(true)

      second = Thread.new do
        ActiveRecord::Base.connection_pool.with_connection do |connection|
          second_pid << connection.select_value("SELECT pg_backend_pid()")
          run_sample_data
        end
      end

      pid = Timeout.timeout(10) { second_pid.pop }
      waited = false
      Timeout.timeout(10) do
        until waited || !second.alive?
          waited = waiting_on_lock?(pid)
          sleep 0.05 unless waited
        end
      end
      expect(waited).to be(true), "la segunda ejecución no esperó el bloqueo de la primera"
    ensure
      release << true
      expect(first.join(10)).to be_truthy
      expect(second.join(10)).to be_truthy if second
    end

    expect(first_result.created.size).to eq(17)
    expect(second.value).to be_success
    expect(second.value.created).to be_empty
    expect([ User.count, Person.count, Assignment.count, SampleDataRecord.count ]).to eq([ 5, 5, 7, 17 ])
  end
end
