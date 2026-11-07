require "rails_helper"

# Mecanismo de autorización (GL-03, P-5) con un controlador **solo de
# prueba** y rutas temporales. Comprueba que las verificaciones de Pundit
# detectan omisiones y que un acceso denegado responde igual que un
# recurso inexistente. No comprueba ninguna regla del producto: las
# rutas reales de personas se prueban en people_spec (GL-05).
class AuthorizationProbePolicy < ApplicationPolicy
  def show?
    false
  end
end

# Permite a cualquier cuenta identificada; sirve para aislar la verificación
# del alcance de la decisión de autorización.
class AuthorizationProbeAllowPolicy < ApplicationPolicy
  def show?
    user.present?
  end
end

class AuthorizationProbeController < ApplicationController
  # Sin decisión de autorización.
  def without_authorize
    skip_policy_scope
    head :ok
  end

  # Autoriza, pero lee un registro sin pasar por el alcance.
  def without_scope
    authorize :probe, :show?, policy_class: AuthorizationProbeAllowPolicy
    Person.find(params[:id])
    head :ok
  end

  # Carga por alcance; el alcance base está vacío.
  def scoped
    record = policy_scope(Person, policy_scope_class: ApplicationPolicy::Scope).find(params[:id])
    authorize record, :show?, policy_class: AuthorizationProbePolicy
    head :ok
  end

  # El registro existe y se autoriza, pero la política lo deniega.
  def denied
    skip_policy_scope
    authorize Person.find(params[:id]), :show?, policy_class: AuthorizationProbePolicy
    head :ok
  end
end

RSpec.describe "Mecanismo de autorización", type: :request do
  let(:user) { create_user }
  let(:person) { create_person }

  around do |example|
    with_routing do |set|
      set.draw do
        resource :session, only: %i[ new create destroy ]
        get "probe/without_authorize" => "authorization_probe#without_authorize"
        get "probe/without_scope/:id" => "authorization_probe#without_scope"
        get "probe/scoped/:id" => "authorization_probe#scoped"
        get "probe/denied/:id" => "authorization_probe#denied"
      end
      example.run
    end
  end

  before { sign_in_as(user) }

  it "falla si la acción termina sin decisión de autorización" do
    expect { get "/probe/without_authorize" }.to raise_error(Pundit::AuthorizationNotPerformedError)
  end

  it "falla si la acción lee registros sin usar el alcance" do
    expect { get "/probe/without_scope/#{person.id}" }.to raise_error(Pundit::PolicyScopingNotPerformedError)
  end

  it "un registro fuera del alcance responde 404, igual que uno inexistente" do
    get "/probe/scoped/#{person.id}"
    out_of_scope = [ response.status, response.body ]

    get "/probe/scoped/#{Person.maximum(:id).to_i + 1000}"
    missing = [ response.status, response.body ]

    expect(out_of_scope.first).to eq(404)
    expect(out_of_scope).to eq(missing)
  end

  it "una acción denegada responde 404, igual que un registro inexistente, sin datos del registro" do
    get "/probe/denied/#{person.id}"
    denied = [ response.status, response.body ]

    get "/probe/scoped/#{Person.maximum(:id).to_i + 1000}"
    missing = [ response.status, response.body ]

    expect(denied.first).to eq(404)
    expect(denied).to eq(missing)
    expect(response.body).not_to include(person.name)
  end
end
