require "rails_helper"

RSpec.describe Session, type: :model do
  let(:user) { create_user }
  let(:now) { Time.zone.local(2026, 11, 2, 10, 0, 0) }

  def session_with(created_at:, last_active_at:)
    user.sessions.create!(created_at: created_at, last_active_at: last_active_at)
  end

  it "no vence recién creada" do
    expect(session_with(created_at: now, last_active_at: now).expired?(at: now)).to be(false)
  end

  describe "por inactividad" do
    it "no vence un segundo antes de las 2 horas" do
      session = session_with(created_at: now - 3.hours, last_active_at: now - 2.hours + 1.second)

      expect(session.expired?(at: now)).to be(false)
    end

    it "vence a las 2 horas exactas sin actividad" do
      session = session_with(created_at: now - 3.hours, last_active_at: now - 2.hours)

      expect(session.expired?(at: now)).to be(true)
    end
  end

  describe "por máximo absoluto" do
    it "no vence un segundo antes de las 12 horas" do
      session = session_with(created_at: now - 12.hours + 1.second, last_active_at: now)

      expect(session.expired?(at: now)).to be(false)
    end

    it "vence a las 12 horas aunque haya actividad reciente" do
      session = session_with(created_at: now - 12.hours, last_active_at: now)

      expect(session.expired?(at: now)).to be(true)
    end
  end

  it "registra la última actividad al crearse" do
    travel_to(now) do
      session = user.sessions.create!

      expect(session.last_active_at).to eq(now)
    end
  end
end
