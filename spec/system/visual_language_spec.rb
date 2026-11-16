require "rails_helper"

# Lenguaje visual común en un navegador real (GL-13, capability
# `visual-language`; P-34, P-35, P-38 y P-40). Se comparan valores
# calculados (contraste WCAG, bordes, alturas, origen de los recursos), no
# píxeles de una captura. Cada pantalla se mira a 1280 y a 375 px.
RSpec.describe "Lenguaje visual común en navegador", type: :system do
  let(:privacy_note) { "Ves solo a quienes tenés asignados y las entradas que podés ver" }
  let(:serif) { "Noto Serif Display" }
  let(:field_border) { "rgb(133, 120, 112)" }  # #857870 (P-34)
  let(:accent) { "rgb(166, 70, 42)" }          # #a6462a, foco y acción principal
  let(:login_background) { "rgb(255, 255, 255)" } # el login conserva su fondo (P-40)
  let(:login_field_text) { "rgb(0, 0, 0)" }      # texto de sus campos antes de GL-13 (M265)
  let(:common_button_text) { "rgb(43, 35, 32)" } # #2b2320, texto del botón común (P-40, M266)

  let!(:leader) { create_user(email_address: "luis.lider@example.test", name: "Luis Líder") }
  let!(:ada) { create_person(name: "Ada Ejemplo", role: "Desarrolladora", team: "Equipo Faro") }
  let!(:draft) { FeedbackEntry.create!(author: leader, person: ada, occurred_on: Date.new(2026, 6, 8), context: "Borrador sobre la demo") }
  let!(:ready) do
    FeedbackEntry.create!(author: leader, person: ada, occurred_on: Date.new(2026, 5, 20), context: "Presentó la demo al equipo",
                          dimension: "teamwork", signal: "positive", status: "ready")
  end

  before { assign(leader, ada) }

  # Funciones de apoyo en la página: contraste WCAG 2.x contra el primer
  # fondo opaco de los ancestros.
  GL13_HELPERS_JS = <<~JS.freeze
    window.__gl13 = window.__gl13 || (function() {
      function rgb(s) { var m = s.match(/[\\d.]+/g).map(Number); return { r: m[0], g: m[1], b: m[2], a: m.length > 3 ? m[3] : 1 }; }
      function lum(c) { return [c.r, c.g, c.b].map(function(v) { v /= 255; return v <= 0.03928 ? v / 12.92 : Math.pow((v + 0.055) / 1.055, 2.4); })
                          .reduce(function(acc, v, i) { return acc + v * [0.2126, 0.7152, 0.0722][i]; }, 0); }
      function ratio(a, b) { var x = lum(a), y = lum(b); return (Math.max(x, y) + 0.05) / (Math.min(x, y) + 0.05); }
      function bg(el) { for (var e = el; e; e = e.parentElement) { var c = rgb(getComputedStyle(e).backgroundColor); if (c.a > 0) return c; } return { r: 255, g: 255, b: 255, a: 1 }; }
      return {
        text: function(el) { return ratio(rgb(getComputedStyle(el).color), bg(el)); },
        border: function(el) { return ratio(rgb(getComputedStyle(el).borderTopColor), bg(el.parentElement)); },
        outline: function(el) { return ratio(rgb(getComputedStyle(el).outlineColor), bg(el.parentElement)); }
      };
    })();
  JS

  def js(script) = page.evaluate_script("(function(){ #{GL13_HELPERS_JS} return #{script}; })()")
  def resize(width) = page.current_window.resize_to(width, 900)
  def style(selector, prop) = js("getComputedStyle(document.querySelector(#{selector.to_json})).#{prop}")
  def height(selector) = js("document.querySelector(#{selector.to_json}).getBoundingClientRect().height")
  def no_horizontal_scroll? = js("document.documentElement.scrollWidth <= window.innerWidth")

  # Filas que ocupa la cabecera (nombre, «Personas», cuenta y «Cerrar
  # sesión»): un elemento abre una fila nueva si empieza debajo del borde
  # inferior de la fila anterior; los que se solapan en vertical comparten fila.
  def header_rows
    js(<<~JS)
      (function() {
        var items = Array.from(document.querySelector(".site-nav").children);
        var boxes = items.filter(function(e) { return e.getClientRects().length > 0; })
                         .map(function(e) { return e.getBoundingClientRect(); })
                         .sort(function(a, b) { return a.top - b.top; });
        var rows = 0, bottom = -Infinity;
        boxes.forEach(function(r) {
          if (r.top >= bottom - 0.5) { rows += 1; bottom = r.bottom; } else { bottom = Math.max(bottom, r.bottom); }
        });
        return { items: items.length, visible: boxes.length, rows: rows };
      })()
    JS
  end

  # La fuente declarada con @font-face terminó de cargarse desde la aplicación.
  def serif_loaded?
    page.evaluate_async_script(<<~JS)
      var done = arguments[0];
      document.fonts.ready.then(function() {
        done(Array.from(document.fonts).some(function(f) { return f.family.replace(/"/g, "") === #{serif.to_json} && f.status === "loaded"; }));
      });
    JS
  end

  # Contraste de todos los elementos con texto propio visible.
  def low_contrast_texts
    js(<<~JS)
      Array.from(document.querySelectorAll("body *")).filter(function(el) {
        var own = Array.from(el.childNodes).some(function(n) { return n.nodeType === 3 && n.textContent.trim() !== ""; });
        var cs = getComputedStyle(el);
        return own && cs.visibility !== "hidden" && cs.display !== "none" && el.getClientRects().length > 0;
      }).map(function(el) { return [el.tagName + "." + el.className, Math.round(window.__gl13.text(el) * 100) / 100]; })
        .filter(function(p) { return p[1] < 4.5; })
    JS
  end

  def foreign_resources
    js(<<~JS)
      performance.getEntriesByType("resource").map(function(r) { return r.name; })
        .filter(function(n) { return n.indexOf(location.origin) !== 0; })
    JS
  end

  def sign_in
    visit new_session_path
    fill_in "Correo", with: leader.email_address
    fill_in "Contraseña", with: leader.password
    click_button "Iniciar sesión"
    expect(page).to have_css("h1", text: "Personas")
  end

  [ 1280, 375 ].each do |width|
    context "a #{width} px" do
      before { resize(width) }

      it "las páginas con sesión tienen contraste AA, sin desplazamiento horizontal ni recursos de terceros" do
        sign_in
        [ people_path, person_path(ada), new_person_feedback_entry_path(ada), feedback_entry_path(draft), edit_feedback_entry_path(ready) ].each do |path|
          visit path
          expect(low_contrast_texts).to eq([]), "contraste bajo en #{path}"
          expect(no_horizontal_scroll?).to be(true), "desplazamiento horizontal en #{path}"
          expect(foreign_resources).to eq([]), "recursos de terceros en #{path}"
        end
      end

      it "la cabecera va arriba, marca el destino actual sin depender del color y mide 44 px" do
        sign_in
        expect(js("document.querySelector('.site-header').getBoundingClientRect().top")).to be <= 0.5
        expect(page).to have_css(".site-nav a[aria-current=page]", text: "Personas")
        expect(style(".site-nav a[aria-current=page]", "fontWeight").to_i).to be >= 600
        expect(style(".site-nav a[aria-current=page]", "backgroundColor")).not_to eq("rgba(0, 0, 0, 0)")
        expect(page).to have_no_link("Feedback")
        expect(page).to have_no_link("Administración")
        expect(height(".site-nav a[aria-current=page]")).to be >= 44
        expect(height(".sign-out button")).to be >= 44
        # visual-language «Pantallas angostas»: la cabecera ocupa dos líneas como
        # máximo, con el nombre de la cuenta y «Cerrar sesión» visibles (M265).
        expect(page).to have_css(".site-account", text: "Sesión iniciada como Luis Líder")
        expect(page).to have_button("Cerrar sesión")
        [ people_path, person_path(ada) ].each do |path|
          visit path
          rows = header_rows
          expect(rows["visible"]).to eq(rows["items"]), "elementos ocultos en la cabecera de #{path}"
          expect(rows["rows"]).to be <= 2, "la cabecera de #{path} ocupa #{rows["rows"]} filas"
          expect(js("document.querySelector('.site-header').getBoundingClientRect().height")).to be <= 2 * 56
        end
      end

      it "la ficha: títulos en serif local, aviso único, borrador distinto y resumen sin forma de puntaje" do
        sign_in
        visit person_path(ada)

        expect(page).to have_css("h1", text: "Ada Ejemplo")
        expect(style("h1", "fontFamily")).to start_with("\"#{serif}\"")
        expect(serif_loaded?).to be(true)

        expect(page).to have_text(privacy_note, count: 1)
        expect(page).to have_no_css("details")

        draft_row = ".entry-row[data-status=draft]"
        ready_row = ".entry-row[data-status=ready]"
        expect(find(draft_row)).to have_text("Borrador · solo vos · fuera del resumen")
        expect(find(ready_row)).to have_text("Lista · solo vos")
        expect(style(draft_row, "borderTopStyle")).to eq("dashed")
        expect(style(ready_row, "borderTopStyle")).not_to eq("dashed")
        expect(style(draft_row, "backgroundColor")).not_to eq(style(ready_row, "backgroundColor"))

        # P-34: el azul es de los enlaces y de lo compartido, no de las señales.
        expect(style("#{ready_row} .entry-row-signal", "color")).not_to eq(style(".back-link a", "color"))

        backgrounds = js("Array.from(document.querySelectorAll('.summary-table tbody tr')).map(function(r){ return getComputedStyle(r).backgroundColor; })")
        expect(backgrounds.uniq.size).to eq(1)
        expect(find("[data-summary]")).to have_no_text("%")
        expect(page).to have_no_css("[data-summary] progress, [data-summary] meter")

        expect(height(".primary-action .button")).to be >= 44
        expect(style(".primary-action .button", "backgroundColor")).to eq(accent)
      end

      it "los campos y el foco tienen al menos 3:1 y las acciones miden 44 px" do
        sign_in
        visit new_person_feedback_entry_path(ada)
        expect(style(".entry-form textarea", "borderTopColor")).to eq(field_border)
        expect(js("window.__gl13.border(document.querySelector('.entry-form textarea'))")).to be >= 3
        # El área de texto recibe el foco al cargar (autofocus) y muestra el contorno.
        expect(js("document.activeElement.tagName")).to eq("TEXTAREA")
        expect(style(".entry-form textarea", "outlineStyle")).to eq("solid")
        expect(style(".entry-form textarea", "outlineColor")).to eq(accent)
        expect(js("window.__gl13.outline(document.querySelector('.entry-form textarea'))")).to be >= 3
        expect(height(".entry-form input[type=submit]")).to be >= 44

        visit feedback_entry_path(draft)
        expect(height(".actions .button")).to be >= 44
        expect(height(".inline-form button")).to be >= 44
      end

      it "los radios de los formularios internos usan el terracota y conservan el foco visible (M265)" do
        sign_in
        visit edit_feedback_entry_path(ready)
        radios = js("Array.from(document.querySelectorAll('.entry-form input[type=radio]')).map(function(r){ return getComputedStyle(r).accentColor; })")
        expect(radios).not_to be_empty
        expect(radios.uniq).to eq([ accent ])

        # Con el teclado: Tab desde «¿Qué pasó?» lleva al radio marcado de «Señal».
        find_field("¿Qué pasó?").send_keys(:tab)
        expect(js("document.activeElement.type")).to eq("radio")
        expect(js("getComputedStyle(document.activeElement).outlineStyle")).to eq("solid")
        expect(js("getComputedStyle(document.activeElement).outlineColor")).to eq(accent)
        expect(js("window.__gl13.outline(document.activeElement)")).to be >= 3
      end
    end
  end

  it "el inicio de sesión conserva su fondo y su tipografía, y hereda solo campos, foco y botón común (P-40)" do
    visit new_session_path
    expect(style("body", "backgroundColor")).to eq(login_background)
    expect(style("h1", "fontFamily")).not_to include(serif)
    expect(page).to have_no_text(privacy_note)
    expect(style("#email_address", "borderTopColor")).to eq(field_border)
    expect(style("#email_address", "outlineColor")).to eq(accent)
    expect(style(".sign-in-form input[type=submit]", "backgroundColor")).not_to eq(accent)
    # P-40, M266: «Iniciar sesión» es un botón común, con su fondo, su borde
    # y su color de texto; no es un botón principal.
    expect(style(".sign-in-form input[type=submit]", "color")).to eq(common_button_text)
    expect(style(".sign-in-form input[type=submit]", "borderTopColor")).to eq(field_border)
    # GL-11 comparte borde, radio y tipografía, no el color del texto: el login
    # conserva el que tenía antes de GL-13 (M265).
    expect(style("#email_address", "color")).to eq(login_field_text)
    expect(style("#password", "color")).to eq(login_field_text)
  end
end
