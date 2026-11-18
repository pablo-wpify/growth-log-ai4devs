require "rails_helper"

# Formulario completo «+ Feedback» en el navegador (GL-15; tareas 1.3 y
# 1.4). Con JavaScript (Chrome sin interfaz, ADR-6) el formulario se abre en
# la ficha sin cambiar de página; sin JavaScript (rack_test) funciona como
# enlace y página comunes. Datos ficticios propios de cada prueba.
RSpec.describe "Formulario completo «+ Feedback»", type: :system do
  let!(:leader) { create_user(email_address: "luis.lider@example.test", name: "Luis Líder") }
  let!(:ada) { create_person(name: "Ada Ejemplo", role: "Desarrolladora", team: "Equipo Faro") }
  let(:context_text) { "Ordenó la retro con ejemplos concretos" }

  before { assign(leader, ada) }

  def sign_in_with_browser(user)
    visit new_session_path
    fill_in "Correo", with: user.email_address
    fill_in "Contraseña", with: user.password
    click_button "Iniciar sesión"
    expect(page).to have_css("h1", text: "Personas")
  end

  def open_person
    sign_in_with_browser(leader)
    click_link "Ada Ejemplo"
    expect(page).to have_css("h1", text: "Ada Ejemplo")
  end

  def form_frame = find("turbo-frame#feedback_form")

  context "con JavaScript" do
    it "abre el formulario en la ficha sin cambiar de página, con la fecha de hoy, y «Cancelar» lo cierra sin guardar" do
      open_person
      ficha_path = current_path

      click_link "+ Feedback"
      within(form_frame) do
        expect(page).to have_css("h2", text: "Nueva entrada")
        expect(find_field("Fecha del hecho").value).to eq(Time.zone.today.iso8601)
      end
      expect(current_path).to eq(ficha_path)
      expect(page).to have_css("h1", text: "Ada Ejemplo")

      within(form_frame) do
        fill_in "¿Qué pasó?", with: context_text
        click_link "Cancelar"
      end
      expect(page).to have_no_css("turbo-frame#feedback_form form")
      expect(current_path).to eq(ficha_path)
      expect(FeedbackEntry.count).to eq(0)
    end

    it "muestra un error de validación dentro de la ficha y después guarda como lista con la fecha elegida" do
      open_person

      click_link "+ Feedback"
      within(form_frame) do
        fill_in "¿Qué pasó?", with: context_text
        click_button "Guardar como lista"
      end
      expect(page).to have_css("h1", text: "Ada Ejemplo")
      within(form_frame) do
        expect(page).to have_text("falta la dimensión")
        expect(page).to have_text("falta la señal")
        fill_in "Fecha del hecho", with: Date.new(2026, 10, 1)
        choose "Positivo"
        choose "Trabajo en equipo"
        click_button "Guardar como lista"
      end

      expect(page).to have_css(".flash-notice", exact_text: "Feedback guardado como lista.")
      expect(page).to have_no_css("turbo-frame#feedback_form form")
      within("[data-timeline]") do
        expect(page).to have_text(context_text)
        expect(page).to have_text("01/10/2026")
        expect(page).to have_text("Lista · solo vos")
      end
      expect(FeedbackEntry.last).to have_attributes(status: "ready", occurred_on: Date.new(2026, 10, 1))
    end
  end

  context "disposición de las acciones del formulario" do
    def action_boxes
      page.evaluate_script(<<~JS)
        Array.from(document.querySelectorAll("turbo-frame#feedback_form .actions > *")).map(function(e) {
          var r = e.getBoundingClientRect();
          return { text: e.textContent.trim(), left: Math.round(r.left), width: Math.round(r.width),
                   top: Math.round(r.top), bottom: Math.round(r.bottom), height: Math.round(r.height) };
        })
      JS
    end

    def expect_stacked(boxes)
      expect(boxes.map { |box| box["text"] }).to eq([ "Guardar borrador", "Guardar como lista", "Cancelar" ])
      expect(boxes.map { |box| box["left"] }.uniq.size).to eq(1), "no empiezan en el mismo borde: #{boxes}"
      expect(boxes.map { |box| box["width"] }.uniq.size).to eq(1), "no tienen el mismo ancho: #{boxes}"
      boxes.each_cons(2) { |upper, lower| expect(lower["top"]).to be >= upper["bottom"] }
      expect(boxes.map { |box| box["height"] }).to all(be >= 44)
    end

    it "a 375 px cada acción ocupa su fila, con el mismo ancho y 44 px de alto, abierto y con errores" do
      page.current_window.resize_to(375, 812)
      open_person

      click_link "+ Feedback"
      find("turbo-frame#feedback_form form")
      expect_stacked(action_boxes)

      within(form_frame) do
        fill_in "¿Qué pasó?", with: context_text
        click_button "Guardar como lista"
      end
      find("turbo-frame#feedback_form", text: "falta la dimensión")
      expect_stacked(action_boxes)
    end

    it "a 1280 px las tres acciones siguen en una sola fila" do
      page.current_window.resize_to(1280, 800)
      open_person

      click_link "+ Feedback"
      find("turbo-frame#feedback_form form")
      boxes = action_boxes
      expect(boxes.map { |box| box["text"] }).to eq([ "Guardar borrador", "Guardar como lista", "Cancelar" ])
      boxes.each_cons(2) { |left, right| expect(right["top"]).to be < left["bottom"] }
    end
  end

  context "sin JavaScript" do
    before { driven_by :rack_test }

    it "el enlace y el formulario funcionan como página común: error, «Cancelar» y guardado" do
      open_person

      click_link "+ Feedback"
      expect(page).to have_css("h1", text: "+ Feedback sobre Ada Ejemplo")
      expect(find_field("Fecha del hecho").value).to eq(Time.zone.today.iso8601)

      click_button "Guardar como lista"
      expect(page).to have_text("Contá qué pasó.")

      click_link "Cancelar"
      expect(page).to have_css("h1", text: "Ada Ejemplo")
      expect(FeedbackEntry.count).to eq(0)

      click_link "+ Feedback"
      fill_in "¿Qué pasó?", with: context_text
      click_button "Guardar borrador"
      expect(page).to have_css(".flash-notice", text: "Guardamos tu borrador. Solo vos podés verlo.")
      within("[data-timeline]") { expect(page).to have_text(context_text) }
      expect(FeedbackEntry.last).to be_draft
    end
  end
end
