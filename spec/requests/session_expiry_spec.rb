require "rails_helper"

RSpec.describe "Vencimiento e invalidación de sesiones", type: :request do
  let(:user) { create_user }
  let(:start) { Time.zone.local(2026, 11, 2, 8, 0, 0) }

  def sign_in_at_start
    travel_to(start) { sign_in_as(user) }
    expect(Session.count).to eq(1)
  end

  it "renueva la última actividad solo si pasaron más de 5 minutos" do
    sign_in_at_start

    travel_to(start + 4.minutes) { get root_path }
    expect(response).to have_http_status(:ok)
    expect(Session.last.last_active_at).to eq(start)

    travel_to(start + 6.minutes) { get root_path }
    expect(response).to have_http_status(:ok)
    expect(Session.last.last_active_at).to eq(start + 6.minutes)
  end

  it "atiende la petición un minuto antes de las 2 horas sin actividad" do
    sign_in_at_start

    travel_to(start + 2.hours - 1.minute) { get root_path }

    expect(response).to have_http_status(:ok)
  end

  it "rechaza y elimina la sesión tras 2 horas sin actividad" do
    sign_in_at_start

    travel_to(start + 2.hours + 1.second) { get root_path }

    expect(response).to redirect_to(new_session_path)
    expect(Session.count).to eq(0)
  end

  it "rechaza a las 12 horas una cookie conservada, aunque haya actividad constante" do
    sign_in_at_start

    (1..11).each do |hour|
      travel_to(start + hour.hours) { get root_path }
      expect(response).to have_http_status(:ok), "falló a las #{hour} h"
    end

    retained_cookie = cookies[:session_id]

    travel_to(start + 12.hours) do
      # El navegador descarta la cookie vencida; quien la conserve puede
      # reenviarla. La firma incluye el vencimiento: el servidor la rechaza.
      cookies[:session_id] = retained_cookie
      get root_path
    end

    expect(response).to redirect_to(new_session_path)
  end

  it "rechaza y elimina la sesión por el máximo absoluto guardado, aunque la cookie siga vigente" do
    sign_in_at_start
    Session.last.update_columns(created_at: start - 12.hours, last_active_at: start)

    travel_to(start + 1.minute) { get root_path }

    expect(response).to redirect_to(new_session_path)
    expect(Session.count).to eq(0)
  end

  it "borra las sesiones vencidas de la cuenta al iniciar una nueva" do
    sign_in_at_start
    delete session_path

    travel_to(start) { sign_in_as(user) }
    stale_id = Session.last.id

    travel_to(start + 13.hours) { sign_in_as(user) }

    expect(Session.exists?(stale_id)).to be(false)
    expect(Session.count).to eq(1)
  end

  it "rechaza y elimina la sesión de una cuenta desactivada en la siguiente petición" do
    sign_in_at_start
    user.update!(deactivated_at: start + 1.minute)

    travel_to(start + 2.minutes) { get root_path }

    expect(response).to redirect_to(new_session_path)
    expect(Session.count).to eq(0)
  end
end
