require "rails_helper"

# Presentación de la página de inicio de sesión en un navegador real
# (GL-11, capability sign-in-presentation; P-32 y P-33 aprobadas en M240):
# etiquetas sobre los campos, campos y botón con el aspecto de la captura
# rápida, ancho máximo de 24 rem con ancho fluido, foco visible y sin
# desplazamiento horizontal a 375 px. Se comparan relaciones y valores
# calculados, no píxeles de una captura.
RSpec.describe "Presentación de la página de inicio de sesión en navegador", type: :system do
  let!(:leader) { create_user(email_address: "luis.lider@example.test", name: "Luis Líder") }
  let!(:person) { create_person(name: "Ada Ejemplo", role: "Desarrolladora", team: "Equipo Faro") }

  before { assign(leader, person) }

  # Color de foco de la aplicación: desde GL-13 (P-34, M264) es el terracota de la paleta, #a6462a.
  FOCUS_RING = { "outlineStyle" => "solid", "outlineWidth" => "3px", "outlineColor" => "rgb(166, 70, 42)", "outlineOffset" => "2px" }.freeze
  FIELD_LOOK = %w[borderTopWidth borderTopStyle borderTopColor borderTopLeftRadius fontFamily fontSize].freeze
  BUTTON_LOOK = %w[borderTopWidth borderTopStyle borderTopColor borderTopLeftRadius backgroundColor fontFamily fontSize].freeze

  def resize(width)
    page.current_window.resize_to(width, 900)
  end

  def box(selector)
    page.evaluate_script(<<~JS)
      (function() {
        var r = document.querySelector(#{selector.to_json}).getBoundingClientRect();
        return { top: r.top, bottom: r.bottom, left: r.left, right: r.right, width: r.width, height: r.height };
      })()
    JS
  end

  def styles(selector, props)
    page.evaluate_script(<<~JS)
      (function() {
        var cs = getComputedStyle(document.querySelector(#{selector.to_json}));
        var out = {};
        #{props.to_json}.forEach(function(p) { out[p] = cs[p]; });
        return out;
      })()
    JS
  end

  def active_element_id = page.evaluate_script("document.activeElement.id || document.activeElement.value")
  def root_font_size = page.evaluate_script("parseFloat(getComputedStyle(document.documentElement).fontSize)")

  def no_horizontal_scroll?
    page.evaluate_script("document.documentElement.scrollWidth <= window.innerWidth")
  end

  # Estilos de referencia de la captura rápida (P-32): campo y botón.
  def quick_capture_reference
    visit new_session_path
    fill_in "Correo", with: leader.email_address
    fill_in "Contraseña", with: leader.password
    click_button "Iniciar sesión"
    expect(page).to have_css("h1", text: "Personas")
    visit new_person_feedback_entry_path(person)
    reference = { field: styles(".entry-form textarea", FIELD_LOOK), button: styles(".entry-form input[type=submit]", BUTTON_LOOK) }
    click_button "Cerrar sesión"
    expect(page).to have_css("h1", text: "Iniciar sesión")
    reference
  end

  def sign_in_page_with_failure
    visit new_session_path
    fill_in "Correo", with: leader.email_address
    fill_in "Contraseña", with: SecureRandom.alphanumeric(20)
    click_button "Iniciar sesión"
    expect(page).to have_css("[role=alert]", text: "Correo o contraseña incorrectos.")
  end

  [ 1280, 375 ].each do |width|
    context "a #{width} px" do
      before { resize(width) }

      it "pone cada etiqueta encima de su campo, alineada con él" do
        visit new_session_path

        [ %w[label[for=email_address] #email_address], %w[label[for=password] #password] ].each do |label, input|
          expect(box(label)["bottom"]).to be <= box(input)["top"]
          expect(box(label)["left"]).to be_within(0.5).of(box(input)["left"])
        end
        expect(box("label[for=password]")["top"]).to be >= box("#email_address")["bottom"]
      end

      it "muestra los campos y el botón con el aspecto de la captura rápida" do
        reference = quick_capture_reference

        email = box("#email_address")
        password = box("#password")
        button = box(".sign-in-form input[type=submit]")

        expect(email["height"]).to be >= 44
        expect(password["height"]).to be >= 44
        expect(email["width"]).to be_within(0.5).of(password["width"])
        expect(styles("#email_address", FIELD_LOOK)).to eq(reference[:field])
        expect(styles("#password", FIELD_LOOK)).to eq(reference[:field])

        expect(button["top"]).to be >= password["bottom"]
        expect(button["left"]).to be_within(0.5).of(password["left"])
        expect(button["height"]).to be >= 44
        expect(styles(".sign-in-form input[type=submit]", BUTTON_LOOK)).to eq(reference[:button])
      end

      it "no tiene desplazamiento horizontal, tampoco con el aviso de fallo" do
        visit new_session_path
        expect(no_horizontal_scroll?).to be(true)

        sign_in_page_with_failure
        expect(no_horizontal_scroll?).to be(true)
        alert = box("[role=alert]")
        expect(alert["top"]).to be < box(".sign-in-form")["top"]
        expect(styles("[role=alert]", %w[borderLeftWidth borderTopStyle])).to eq("borderLeftWidth" => "4px", "borderTopStyle" => "solid")
        expect(page).to have_no_css("[aria-invalid]")
      end
    end
  end

  it "a 1280 px el formulario mide 24 rem y no se estira al contenedor (P-33)" do
    resize(1280)
    visit new_session_path

    max = 24 * root_font_size
    expect(box(".sign-in-form")["width"]).to be_within(0.5).of(max)
    expect(box("#email_address")["width"]).to be_within(0.5).of(max)
    expect(box("main.container")["width"]).to be > max
  end

  it "a 375 px el formulario ocupa todo el ancho disponible del contenedor (P-33)" do
    resize(375)
    visit new_session_path

    content_width = page.evaluate_script(<<~JS)
      (function() {
        var c = document.querySelector("main.container"), cs = getComputedStyle(c);
        return c.clientWidth - parseFloat(cs.paddingLeft) - parseFloat(cs.paddingRight);
      })()
    JS
    expect(box(".sign-in-form")["width"]).to be_within(0.5).of(content_width)
    expect(content_width).to be < 24 * root_font_size
  end

  it "muestra el foco de la aplicación en el correo al cargar y en la contraseña y el botón con Tab" do
    visit new_session_path

    expect(active_element_id).to eq("email_address")
    expect(styles("#email_address", FOCUS_RING.keys)).to eq(FOCUS_RING)

    page.driver.browser.action.send_keys(:tab).perform
    expect(active_element_id).to eq("password")
    expect(styles("#password", FOCUS_RING.keys)).to eq(FOCUS_RING)

    page.driver.browser.action.send_keys(:tab).perform
    expect(active_element_id).to eq("Iniciar sesión")
    expect(styles(".sign-in-form input[type=submit]", FOCUS_RING.keys)).to eq(FOCUS_RING)
  end
end
