require "rails_helper"

RSpec.describe Assignment, type: :model do
  let(:leader) { create_user(email_address: "luis.lider@example.test") }
  let(:other_leader) { create_user(email_address: "lara.lider@example.test", name: "Lara Líder") }
  let(:person) { create_person(name: "Ada Ejemplo") }
  let(:other_person) { create_person(name: "Bruno Ejemplo") }

  describe "datos obligatorios" do
    it "la base rechaza una asignación sin líder" do
      expect {
        Assignment.new(person: person, started_at: Time.current).save!(validate: false)
      }.to raise_error(ActiveRecord::NotNullViolation)
    end

    it "la base rechaza una asignación sin persona" do
      expect {
        Assignment.new(leader: leader, started_at: Time.current).save!(validate: false)
      }.to raise_error(ActiveRecord::NotNullViolation)
    end

    it "la base rechaza una asignación sin fecha de inicio" do
      expect {
        Assignment.new(leader: leader, person: person).save!(validate: false)
      }.to raise_error(ActiveRecord::NotNullViolation)
    end

    it "la base rechaza un fin anterior al inicio" do
      expect {
        Assignment.new(leader: leader, person: person, started_at: Time.current, ended_at: 1.day.ago).save!(validate: false)
      }.to raise_error(ActiveRecord::CheckViolation)
    end

    it "acepta un fin igual al inicio" do
      now = Time.current

      expect(assign(leader, person, started_at: now, ended_at: now)).to be_persisted
    end
  end

  describe "una asignación activa por par líder y persona" do
    it "acepta dos líderes con asignación activa con la misma persona" do
      assign(leader, person)
      assign(other_leader, person)

      expect(Assignment.active.where(person: person).count).to eq(2)
    end

    it "acepta un líder con asignaciones activas con dos personas" do
      assign(leader, person)
      assign(leader, other_person)

      expect(Assignment.active.where(leader: leader).count).to eq(2)
    end

    it "la base rechaza una segunda asignación activa del mismo par" do
      assign(leader, person)

      expect {
        Assignment.new(leader: leader, person: person, started_at: Time.current).save!(validate: false)
      }.to raise_error(ActiveRecord::RecordNotUnique)
    end

    it "acepta una reasignación después de terminar la anterior, que se conserva" do
      first = assign(leader, person, started_at: 10.days.ago)
      first.update!(ended_at: 5.days.ago)

      second = assign(leader, person, started_at: 1.day.ago)

      expect(second).to be_persisted
      expect(Assignment.where(leader: leader, person: person).count).to eq(2)
      expect(Assignment.active.where(leader: leader, person: person)).to contain_exactly(second)
    end
  end

  describe "estados independientes" do
    it "terminar una asignación no cambia la persona ni la cuenta" do
      assignment = assign(leader, person)

      assignment.update!(ended_at: Time.current)

      expect(person.reload).to be_active
      expect(leader.reload).to be_active
    end

    it "desactivar la cuenta líder no termina sus asignaciones" do
      assignment = assign(leader, person)

      leader.update!(deactivated_at: Time.current)

      expect(assignment.reload.ended_at).to be_nil
    end
  end
end
