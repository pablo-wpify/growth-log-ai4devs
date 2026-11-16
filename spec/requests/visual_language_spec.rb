require "rails_helper"

# Lenguaje visual común (GL-13, capability `visual-language`, y delta de
# `people-browsing` «Aviso de privacidad en la ficha»). Comprueba lo que se
# ve en el HTML y en las fuentes, sin navegador: sin estilos en línea, tokens
# en :root, recursos propios, licencia de la fuente y textos de la ficha.
RSpec.describe "Lenguaje visual común", type: :request do
  let(:stylesheet) { Rails.root.join("app/assets/stylesheets/application.css") }
  let(:font_dir) { Rails.root.join("app/assets/fonts/noto-serif-display") }
  let(:privacy_note) { "Ves solo a quienes tenés asignados y las entradas que podés ver" }

  let!(:leader) { create_user(email_address: "luis.lider@example.test", name: "Luis Líder") }
  let!(:person) { create_person(name: "Ada Ejemplo", role: "Desarrolladora", team: "Equipo Faro") }

  before { assign(leader, person) }

  def css = stylesheet.read
  def root_block = css[/:root\s*\{[^}]*\}/m]
  def page_html = Nokogiri::HTML(response.body)

  describe "tokens y hoja de estilos" do
    it "define los colores en :root y las reglas los usan por nombre" do
      expect(root_block).to include("--accent:", "--field-border:", "--focus:", "--bg:")
      rules = css.sub(root_block, "")
      expect(rules.scan(/#\h{3,8}\b|rgba?\(/)).to be_empty
    end

    it "da color a los radios solo en las páginas con sesión, sin tocar el inicio de sesión (M265)" do
      rules = css.gsub(%r{/\*.*?\*/}m, "").scan(/([^{}]+)\{[^}]*accent-color:[^}]*\}/m).flatten.map(&:strip)
      expect(rules).not_to be_empty
      expect(rules.flat_map { |r| r.split(",").map(&:strip) }).to all(start_with("body.app "))
    end

    it "no pide recursos de otros dominios" do
      expect(css).not_to match(%r{url\(\s*["']?(https?:)?//}i)
      expect(css).not_to match(/@import/i)
    end

    it "sirve la fuente serif OFL desde la aplicación, con su licencia versionada" do
      expect(css).to match(/@font-face\s*\{[^}]*font-family:\s*"Noto Serif Display"[^}]*url\(["']?noto-serif-display\//m)
      expect(Dir[font_dir.join("*.{ttf,woff,woff2}")]).not_to be_empty
      expect(font_dir.join("OFL.txt").read).to include("SIL OPEN FONT LICENSE Version 1.1")
    end
  end

  it "ninguna vista tiene atributos style" do
    offenders = Dir[Rails.root.join("app/views/**/*.erb")].select { |f| File.read(f).match?(/\bstyle\s*=/i) }
    expect(offenders).to be_empty
  end

  describe "ficha" do
    before do
      FeedbackEntry.create!(author: leader, person:, occurred_on: Date.new(2026, 5, 20), context: "Presentó la demo",
                            dimension: "teamwork", signal: "positive", status: "ready")
      FeedbackEntry.create!(author: leader, person:, occurred_on: Date.new(2026, 6, 8), context: "Borrador de prueba")
      sign_in_as(leader)
      get person_path(person)
    end

    it "muestra una sola vez el aviso breve de privacidad, sin panel «Quién ve qué»" do
      expect(response.body.scan(privacy_note).size).to eq(1)
      expect(response.body).not_to include("Quién ve qué")
      expect(page_html.css("details")).to be_empty
    end

    it "conserva las etiquetas de privacidad de cada entrada" do
      expect(response.body).to include("Borrador · solo vos · fuera del resumen", "Lista · solo vos")
    end

    it "marca las páginas con sesión y no muestra destinos inexistentes" do
      expect(page_html.at_css("body")["class"].to_s.split).to include("app")
      nav = page_html.at_css("nav").text
      expect(nav).to include("Personas", "Cerrar sesión")
      expect(nav).not_to include("Feedback", "Administración")
    end
  end

  it "el inicio de sesión no lleva la marca de las páginas con sesión ni el aviso" do
    get new_session_path
    expect(page_html.at_css("body")["class"].to_s.split).not_to include("app")
    expect(response.body).not_to include(privacy_note)
  end
end
