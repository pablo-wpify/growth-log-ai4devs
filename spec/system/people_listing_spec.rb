require "rails_helper"

# Listado «Personas» de GL-14 en un navegador real (spec `people-browsing`;
# P-43, P-44 y P-47 a P-51). Búsqueda, filtro y orden se aplican en el
# navegador sobre las filas que ya mostró el servidor. Datos ficticios
# propios de cada prueba; L2 es el actor que no debe influir.
RSpec.describe "Listado «Personas» en navegador (GL-14)", type: :system do
  let!(:l1) { create_user(email_address: "luis.lider@example.test", name: "Luis Líder") }
  let!(:l2) { create_user(email_address: "lara.lider@example.test", name: "Lara Líder") }
  let!(:l3) { create_user(email_address: "leo.lider@example.test", name: "Leo Líder") }

  # Creadas fuera de orden para comprobar el orden por nombre.
  let!(:carla) { create_person(name: "Carla Muestra", role: "Analista", team: "Equipo Faro") }
  let!(:ines) { create_person(name: "Inés Prueba", role: "Desarrolladora", team: "Equipo Norte") }
  let!(:ada) { create_person(name: "Ada Ejemplo", role: "Desarrolladora", team: "Equipo Faro") }
  let!(:bruno) { create_person(name: "Bruno Ejemplo", role: "Diseñador", team: nil) }
  let!(:outsider) { create_person(name: "Olga Ajena", role: "Analista", team: "Equipo Brújula") }

  before do
    [ carla, ines, ada, bruno ].each { |person| assign(l1, person) }
    assign(l2, ines)
    # Ada: 20/05; Inés: 01/04 propia y 10/06 de L2; Carla: solo un borrador del
    # 08/06; Bruno: sin entradas.
    entry(ada, on: Date.new(2026, 5, 20))
    entry(ines, on: Date.new(2026, 4, 1))
    entry(ines, author: l2, on: Date.new(2026, 6, 10))
    entry(carla, status: "draft", on: Date.new(2026, 6, 8))
  end

  def entry(person, author: l1, status: "ready", on: Date.new(2026, 5, 20))
    attributes = { author:, person:, occurred_on: on, context: "Entrada de prueba", status: }
    attributes.merge!(signal: "positive", dimension: "teamwork") if status == "ready"
    FeedbackEntry.create!(**attributes)
  end

  def sign_in(user = l1)
    visit new_session_path
    fill_in "Correo", with: user.email_address
    fill_in "Contraseña", with: user.password
    click_button "Iniciar sesión"
    expect(page).to have_css("h1", text: "Personas")
  end

  def js(script) = page.evaluate_script(script)
  def resize(width) = page.current_window.resize_to(width, 900)
  def visible_names = all("li[data-person-row] [data-person-name]").map(&:text)
  def no_horizontal_scroll? = js("document.documentElement.scrollWidth <= window.innerWidth")
  # Peticiones hechas por la página, después de que terminaron de cargar las
  # fuentes, para no confundir la carga diferida de la serif con una petición.
  def requested_resources
    page.evaluate_async_script(<<~JS)
      var done = arguments[0];
      document.fonts.ready.then(function() {
        done(performance.getEntriesByType("navigation").concat(performance.getEntriesByType("resource"))
          .map(function(r) { return r.name.replace(location.origin, ""); }));
      });
    JS
  end
  def height(selector) = js("document.querySelector(#{selector.to_json}).getBoundingClientRect().height")

  [ 1280, 375 ].each do |width|
    context "a #{width} px" do
      before { resize(width) }

      it "cada fila recibe el foco una vez, con foco visible, y «Registrar la primera» es el Tab siguiente" do
        sign_in
        find("select[data-people-list-target=order]").send_keys(:tab)
        expect(js("document.activeElement.dataset.personLink !== undefined")).to be(true)
        expect(js("document.activeElement.textContent.trim()")).to eq("Ada Ejemplo")
        row_outline = js("getComputedStyle(document.activeElement.closest('li')).outlineStyle")
        expect(row_outline).to eq("solid")

        # Ada, Bruno (sin entradas: su atajo), Carla e Inés.
        sequence = [ js("document.activeElement.textContent.trim()") ]
        4.times do
          page.driver.browser.action.send_keys(:tab).perform
          sequence << js("document.activeElement.getAttribute('aria-label') || document.activeElement.textContent.trim()")
        end
        expect(sequence).to eq([ "Ada Ejemplo", "Bruno Ejemplo", "Registrar la primera entrada sobre Bruno Ejemplo",
                                 "Carla Muestra", "Inés Prueba" ])

        expect(js("document.querySelectorAll('li[data-person-row] a a, li[data-person-row] a button').length")).to eq(0)

        # Enter en la persona abre la ficha.
        visit people_path
        find("a[data-person-link]", text: "Ada Ejemplo").send_keys(:enter)
        expect(page).to have_css("h1", text: "Ada Ejemplo")
      end

      it "busca por coincidencia parcial sin mayúsculas ni acentos, sin cambiar la URL ni pedir nada al servidor" do
        sign_in
        url = current_url
        requests = requested_resources

        fill_in "Buscar por nombre", with: "ines"
        expect(visible_names).to eq([ "Inés Prueba" ])
        fill_in "Buscar por nombre", with: "PRU"
        expect(visible_names).to eq([ "Inés Prueba" ])
        fill_in "Buscar por nombre", with: "Olga"
        expect(page).to have_text("Ninguna persona coincide con la búsqueda o el filtro")

        expect(current_url).to eq(url)
        expect(requested_resources - requests).to eq([])
      end

      it "filtra solo con los equipos de las personas asignadas y «Sin equipo indicado»" do
        sign_in
        options = all("select[data-people-list-target=team] option").map(&:text)
        expect(options).to eq([ "Todos", "Equipo Faro", "Equipo Norte", "Sin equipo indicado" ])

        select "Sin equipo indicado", from: "Equipo"
        expect(visible_names).to eq([ "Bruno Ejemplo" ])
        select "Equipo Faro", from: "Equipo"
        expect(visible_names).to eq([ "Ada Ejemplo", "Carla Muestra" ])
      end

      it "ordena por hechos más recientes, con las personas sin entradas listas al final, y por nombre por defecto" do
        sign_in
        expect(visible_names).to eq([ "Ada Ejemplo", "Bruno Ejemplo", "Carla Muestra", "Inés Prueba" ])

        select "Hechos más recientes", from: "Orden"
        # Ada (20/05) e Inés (01/04, sin contar la del 10/06 de L2); Bruno y
        # Carla no tienen entradas listas: al final, por nombre.
        expect(visible_names).to eq([ "Ada Ejemplo", "Inés Prueba", "Bruno Ejemplo", "Carla Muestra" ])

        select "Nombre", from: "Orden"
        expect(visible_names).to eq([ "Ada Ejemplo", "Bruno Ejemplo", "Carla Muestra", "Inés Prueba" ])
      end

      it "desempata la fecha del último hecho por nombre" do
        entry(carla, on: Date.new(2026, 5, 20))
        sign_in
        select "Hechos más recientes", from: "Orden"
        expect(visible_names).to eq([ "Ada Ejemplo", "Carla Muestra", "Inés Prueba", "Bruno Ejemplo" ])
      end

      it "ofrece «Limpiar filtros» con filtros activos, haya o no resultados, y conserva el orden" do
        sign_in
        expect(page).to have_no_button("Limpiar filtros")

        select "Hechos más recientes", from: "Orden"
        select "Equipo Faro", from: "Equipo"
        expect(visible_names).to eq([ "Ada Ejemplo", "Carla Muestra" ])
        expect(page).to have_button("Limpiar filtros")

        fill_in "Buscar por nombre", with: "Zoe"
        expect(page).to have_text("Ninguna persona coincide con la búsqueda o el filtro")
        expect(page).to have_no_text("Todavía no tenés personas asignadas")
        click_button "Limpiar filtros"

        expect(find_field("Buscar por nombre").value).to eq("")
        expect(find_field("Equipo").value).to eq("")
        expect(page).to have_select("Orden", selected: "Hechos más recientes")
        expect(visible_names).to eq([ "Ada Ejemplo", "Inés Prueba", "Bruno Ejemplo", "Carla Muestra" ])
        expect(page).to have_no_text("Ninguna persona coincide con la búsqueda o el filtro")
        expect(page).to have_no_button("Limpiar filtros")
        expect(page).to have_text("4 personas que acompañás")
      end

      it "el estado vacío no tiene controles ni total, y es distinto de sin resultados" do
        sign_in(l3)
        expect(page).to have_text("Todavía no tenés personas asignadas.")
        expect(page).to have_no_field("Buscar por nombre")
        expect(page).to have_no_text("personas que acompañás")
        expect(page).to have_no_text("Ninguna persona coincide con la búsqueda o el filtro")
      end

      it "al recargar vuelve el listado completo por nombre, sin búsqueda ni filtro" do
        sign_in
        fill_in "Buscar por nombre", with: "Ada"
        select "Equipo Faro", from: "Equipo"
        select "Hechos más recientes", from: "Orden"
        page.driver.browser.navigate.refresh

        expect(page).to have_field("Buscar por nombre", with: "")
        expect(page).to have_select("Equipo", selected: "Todos")
        expect(page).to have_select("Orden", selected: "Nombre")
        expect(visible_names).to eq([ "Ada Ejemplo", "Bruno Ejemplo", "Carla Muestra", "Inés Prueba" ])
      end

      it "no se desplaza en horizontal y los controles y «Registrar la primera» miden 44 px" do
        sign_in
        expect(no_horizontal_scroll?).to be(true)
        %w[input[data-people-list-target=query] select[data-people-list-target=team] select[data-people-list-target=order] a[data-first-entry]].each do |selector|
          expect(height(selector)).to be >= 44, "#{selector} mide menos de 44 px"
        end
        if width == 375
          tops = js("Array.from(document.querySelectorAll('[data-people-list-target=controls] input, [data-people-list-target=controls] select')).map(function(e){ return Math.round(e.getBoundingClientRect().top); })")
          expect(tops).to eq(tops.sort)
          expect(tops.uniq.size).to eq(3)
        end
      end
    end
  end

  # GL-17 (P-54 y P-55): presentación del total y el aviso, de «Registrar la
  # primera» y de los detalles de la fila, a ambos lados del corte de 40 rem.
  describe "presentación (GL-17)", :aggregate_failures do
    def rect(selector, within: nil)
      scope = within ? "document.querySelector(#{within.to_json})" : "document"
      js("(function(){ var b = #{scope}.querySelector(#{selector.to_json}).getBoundingClientRect(); return { left: b.left, right: b.right, top: b.top, bottom: b.bottom, width: b.width, height: b.height }; })()")
        .transform_keys(&:to_sym)
    end

    def style(selector, property)
      js("getComputedStyle(document.querySelector(#{selector.to_json}))[#{property.to_json}]")
    end

    # Bruno no tiene entradas: su fila tiene «Registrar la primera».
    let(:bruno_row) { "li[data-person-row][data-search-name='bruno ejemplo']" }

    { 1280 => :right, 640 => :right, 639 => :below, 375 => :below }.each do |width, details_position|
      context "a #{width} px" do
        before { resize(width) }

        it "muestra el total y el aviso en líneas separadas, sin «·», y los detalles #{details_position == :right ? 'a la derecha' : 'debajo'} de «rol · equipo»" do
          sign_in
          expect(js("window.innerWidth")).to eq(width)
          expect(no_horizontal_scroll?).to be(true)

          # P-54: dos líneas, el total arriba, sin separador.
          expect(all("[data-people-total]").size).to eq(1)
          expect(find(".people-summary").text).not_to include("·")
          total = rect("[data-people-total]")
          note = rect(".privacy-note")
          expect(note[:top]).to be >= total[:bottom] - 1

          # P-55: ubicación de los detalles respecto de «rol · equipo».
          meta = rect(".person-meta", within: bruno_row)
          details = rect(".person-details", within: bruno_row)
          if details_position == :right
            expect(details[:left]).to be >= meta[:right] - 1
            expect(details[:top]).to be < meta[:bottom]
          else
            expect(details[:top]).to be >= meta[:bottom] - 1
          end
        end

        it "presenta «Registrar la primera» como acción secundaria con borde, de 44 px y más angosta que la fila" do
          sign_in
          link = "#{bruno_row} a[data-first-entry]"
          expect(style(link, "borderTopStyle")).to eq("solid")
          expect(style(link, "borderTopWidth").to_f).to be >= 1
          expect(rect(link)[:height]).to be >= 44
          # El escenario pide que sea más angosta que la fila (no que ocupe su ancho).
          expect(rect(link)[:width]).to be < rect(".person-details", within: bruno_row)[:width]
          # Ni el fondo de la píldora del conteo ni el de un botón principal.
          background = style(link, "backgroundColor")
          expect(background).not_to eq(style("#{bruno_row} [data-entry-count]", "backgroundColor"))
          expect(background).not_to eq("rgb(166, 70, 42)") # --accent, el fondo de .button-primary
          expect(find(link)[:"aria-label"]).to eq("Registrar la primera entrada sobre Bruno Ejemplo")
        end
      end
    end
  end

  context "sin JavaScript" do
    before { driven_by :rack_test }

    it "muestra todas las personas por nombre y no muestra la búsqueda, el filtro ni el orden" do
      visit new_session_path
      fill_in "Correo", with: l1.email_address
      fill_in "Contraseña", with: l1.password
      click_button "Iniciar sesión"

      expect(visible_names).to eq([ "Ada Ejemplo", "Bruno Ejemplo", "Carla Muestra", "Inés Prueba" ])
      expect(page).to have_no_field("Buscar por nombre")
      expect(page).to have_no_select("Equipo")
      expect(page).to have_no_select("Orden")
      expect(page).to have_link("Registrar la primera")
    end
  end
end
