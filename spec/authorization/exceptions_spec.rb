require "rails_helper"

# Excepciones de autorización declaradas por acción (GL-03). Busca en app/
# toda omisión de las verificaciones de Pundit y la compara, por
# controlador y acción, con esta lista.
RSpec.describe "Excepciones de autorización" do
  DECLARED = [
    # Sin cuenta identificada: no hay a quién autorizar.
    [ "SessionsController", "new", "verify_authorized" ],
    [ "SessionsController", "new", "verify_policy_scoped" ],
    [ "SessionsController", "create", "verify_authorized" ],
    [ "SessionsController", "create", "verify_policy_scoped" ],
    # Autorizadas, pero sin leer registros.
    [ "SessionsController", "destroy", "verify_policy_scoped" ],
    [ "HomeController", "show", "verify_policy_scoped" ]
  ].freeze

  SKIP_CALL = /\b(skip_after_action|skip_authorization|skip_policy_scope|skip_verify_\w+)\b/

  def omissions
    Rails.root.glob("app/**/*.rb").flat_map do |file|
      klass = nil
      action = nil
      File.readlines(file).filter_map do |line|
        klass = Regexp.last_match(1) if line =~ /^\s*class\s+(\w+)/
        action = Regexp.last_match(1) if line =~ /^\s*def\s+(\w+)/
        next unless line =~ SKIP_CALL

        { file: file.relative_path_from(Rails.root).to_s, klass: klass, action: action, line: line.strip }
      end
    end
  end

  def expand(omission)
    line = omission[:line]
    case line
    when /skip_after_action/
      verifications = line.scan(/:(verify_\w+)/).flatten
      actions = line[/only:\s*%i\[([^\]]*)\]/, 1]&.split || Array(line[/only:\s*:(\w+)/, 1])
      actions = [ "*" ] if actions.empty? # sin only: afecta a todo el controlador
      actions.product(verifications).map { |a, v| [ omission[:klass], a, v ] }
    when /skip_authorization/
      [ [ omission[:klass], omission[:action], "verify_authorized" ] ]
    when /skip_policy_scope/
      [ [ omission[:klass], omission[:action], "verify_policy_scoped" ] ]
    else
      [ [ omission[:klass], omission[:action], line ] ]
    end
  end

  it "las omisiones en app/ coinciden exactamente con la lista declarada" do
    expect(omissions.flat_map { |omission| expand(omission) }).to match_array(DECLARED)
  end

  it "ApplicationController instala las dos verificaciones" do
    filters = ApplicationController._process_action_callbacks.select { |c| c.kind == :after }.map(&:filter)

    expect(filters).to include(:verify_authorized, :verify_policy_scoped)
  end

  describe "acción nueva en un controlador con excepciones", type: :request do
    let(:probe_controller) do
      Class.new(SessionsController) do
        def self.name = "SessionsProbeController"

        def probe
          head :ok
        end
      end
    end

    before { stub_const("SessionsProbeController", probe_controller) }

    around do |example|
      with_routing do |set|
        set.draw do
          resource :session, only: %i[ new create destroy ]
          get "sessions_probe" => "sessions_probe#probe"
        end
        example.run
      end
    end

    it "queda sujeta a las verificaciones" do
      sign_in_as(create_user)

      expect { get "/sessions_probe" }.to raise_error(Pundit::AuthorizationNotPerformedError)
    end
  end
end
