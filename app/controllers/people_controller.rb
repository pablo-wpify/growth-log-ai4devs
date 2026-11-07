# «Personas» y ficha del líder (GL-05). Solo lectura. Todo registro se lee
# por el alcance de PersonPolicy (GL-03): una persona fuera del alcance no se
# encuentra y responde el mismo 404 que una inexistente.
class PeopleController < ApplicationController
  def index
    authorize Person
    @people = policy_scope(Person).order(:name, :id)
  end

  def show
    @person = policy_scope(Person).find(params[:id])
    authorize @person
  end
end
