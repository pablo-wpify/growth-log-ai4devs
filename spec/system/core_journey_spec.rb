require "rails_helper"

# Recorrido núcleo y rama negativa de privacidad en un navegador real
# (GL-09; P-4: Capybara y selenium-webdriver con Chrome sin interfaz).
# Spec `quality-pipeline`: «Recorrido núcleo en navegador» y «Rama negativa
# de privacidad en navegador». Datos ficticios propios de cada prueba: L1 y
# L2 acompañan a la misma persona P.
RSpec.describe "Recorrido núcleo en navegador", type: :system do
  let!(:l1) { create_user(email_address: "luis.lider@example.test", name: "Luis Líder") }
  let!(:l2) { create_user(email_address: "lara.lider@example.test", name: "Lara Líder") }
  let!(:ada) { create_person(name: "Ada Ejemplo", role: "Desarrolladora", team: "Equipo Faro") }

  before do
    assign(l1, ada)
    assign(l2, ada)
  end

  def sign_in_with_browser(user)
    visit new_session_path
    fill_in "Correo", with: user.email_address
    fill_in "Contraseña", with: user.password
    click_button "Iniciar sesión"
    expect(page).to have_css("h1", text: "Personas")
  end

  def summary = find("[data-summary]")
  def timeline = find("[data-timeline]")

  it "L1 captura, completa y marca como lista una entrada, y la ve en el resumen y en la cronología" do
    context_text = "Presentó la demo al equipo con calma"

    # E1 y E2: iniciar sesión, elegir la persona y abrir la captura rápida.
    sign_in_with_browser(l1)
    click_link "Ada Ejemplo"
    expect(page).to have_css("h1", text: "Ada Ejemplo")
    click_link "Captura rápida"

    # E3: el borrador aparece en la cronología, fuera del resumen.
    fill_in "¿Qué pasó?", with: context_text
    click_button "Guardar borrador"
    expect(page).to have_text("Guardamos tu borrador. Solo vos podés verlo.")
    expect(timeline).to have_text("Borrador · solo vos · fuera del resumen")
    expect(timeline).to have_text(context_text)
    expect(summary).to have_text("Todavía no hay entradas listas para el resumen.")

    # E4: completar señal y dimensión, y marcar como lista.
    within("[data-timeline]") { click_link href: %r{/entradas/\d+\z} }
    click_link "Editar"
    choose "Positivo"
    choose "Trabajo en equipo"
    click_button "Guardar cambios"
    expect(page).to have_text("Guardamos los cambios. Solo vos podés ver esta entrada.")
    click_button "Marcar como lista"
    expect(page).to have_text("La entrada está lista y sigue siendo privada: solo vos podés verla.")

    # E5: la entrada cuenta en el resumen y aparece lista en la cronología.
    click_link "← Volver a Ada Ejemplo"
    within("[data-summary] tbody") do
      expect(page).to have_css("tr", count: 1)
      expect(find("tr").all("th, td").map(&:text)).to eq([ "Trabajo en equipo", "1", "0", "0", "1" ])
    end
    expect(timeline).to have_text("Lista · solo vos")
    expect(timeline).to have_text(context_text)
    expect(timeline).to have_no_text("fuera del resumen")
  end

  it "L2, asignado a la misma persona, no ve las entradas de L1 en la ficha ni por URL directa" do
    ready_text = "Entrada lista privada de Luis"
    draft_text = "Borrador privado de Luis"
    ready = FeedbackEntry.create!(author: l1, person: ada, occurred_on: Date.new(2026, 11, 10), context: ready_text,
                                  status: "ready", signal: "positive", dimension: "teamwork")
    draft = FeedbackEntry.create!(author: l1, person: ada, occurred_on: Date.new(2026, 11, 11), context: draft_text,
                                  signal: "improvement", dimension: "delivery")

    sign_in_with_browser(l2)
    click_link "Ada Ejemplo"

    # N1: ni el resumen ni la cronología de L2 muestran las entradas de L1.
    expect(summary).to have_text("Todavía no hay entradas listas para el resumen.")
    expect(summary).to have_no_css("table")
    expect(timeline).to have_text("Todavía no registraste entradas sobre Ada Ejemplo.")
    expect(timeline).to have_no_css("li")
    expect(page).to have_no_text(ready_text)
    expect(page).to have_no_text(draft_text)

    # N2: por URL directa, el detalle responde la página 404, sin el texto.
    [ [ ready, ready_text ], [ draft, draft_text ] ].each do |entry, text|
      visit feedback_entry_path(entry)
      expect(page).to have_title(/404/)
      expect(page).to have_no_text(text)
    end
  end
end
