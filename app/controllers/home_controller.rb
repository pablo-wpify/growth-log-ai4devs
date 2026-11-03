# Página de inicio provisoria (GL-02): confirma la sesión y permite cerrarla.
# La reemplaza la vista «Personas» en GL-05.
class HomeController < ApplicationController
  def show
    authorize :home, :show?
    skip_policy_scope # no lee registros
  end
end
