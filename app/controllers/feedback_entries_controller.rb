# Entradas de feedback (GL-06). Toda lectura por id pasa por un alcance:
# la persona, por el de personas (GL-03); la entrada, por el de entradas
# (lectura por autoría). `authorize` decide la acción concreta. Un recurso
# fuera del alcance o una acción denegada responden el mismo 404 que uno
# inexistente. Sin excepciones a las verificaciones de Pundit.
class FeedbackEntriesController < ApplicationController
  include PersonPage

  # GL-15: avisos al guardar el formulario completo. El de lista es genérico:
  # confirma el guardado, sin el texto del feedback ni a quién se refiere
  # (diseño de GL-15, sección 4.3).
  COMPLETE_NOTICES = {
    "draft" => "Guardamos tu borrador. Solo vos podés verlo.",
    "ready" => "Feedback guardado como lista."
  }.freeze

  # Captura rápida en página propia (P-22): solo el texto.
  def new
    @person = policy_scope(Person).find(params[:person_id])
    @entry = @person.feedback_entries.new(author: Current.user, occurred_on: Time.zone.today)
    authorize @entry
  end

  def create
    @person = policy_scope(Person).find(params[:person_id])
    @entry = @person.feedback_entries.new(author: Current.user, status: "draft",
                                          occurred_on: Time.zone.today, context: capture_params[:context])
    authorize @entry

    if @entry.save
      redirect_to person_path(@person), notice: "Guardamos tu borrador. Solo vos podés verlo."
    else
      render :new, status: :unprocessable_content
    end
  end

  # GL-15: formulario completo «+ Feedback». Se abre en un Turbo Frame de la
  # ficha; sin JavaScript, como página propia. La fecha se precarga con hoy
  # en la zona de la aplicación (P-23) y se puede cambiar.
  def new_complete
    @person = policy_scope(Person).find(params[:person_id])
    @entry = @person.feedback_entries.new(author: Current.user, occurred_on: Time.zone.today)
    authorize @entry, :create?
  end

  # El estado sale del botón elegido («Guardar borrador» o «Guardar como
  # lista»). Sin estado, el modelo deja la entrada en borrador; un valor
  # desconocido es un error de validación del modelo, no un borrador. Autor
  # y persona salen de la sesión y del alcance, nunca de los parámetros.
  # Con error, se vuelve a mostrar la ficha con el formulario y los errores.
  def create_complete
    @person = policy_scope(Person).find(params[:person_id])
    @entry = @person.feedback_entries.new(author: Current.user)
    authorize @entry, :create?
    @entry.assign_attributes(complete_params)

    if @entry.save
      redirect_to person_path(@person), notice: COMPLETE_NOTICES.fetch(@entry.status)
    else
      load_person_page(@person)
      @complete_entry = @entry
      render "people/show", status: :unprocessable_content
    end
  end

  def show
    load_entry
  end

  def edit
    load_entry
  end

  def update
    load_entry

    if @entry.update(entry_params)
      redirect_to feedback_entry_path(@entry), notice: "Guardamos los cambios. Solo vos podés ver esta entrada."
    else
      render :edit, status: :unprocessable_content
    end
  end

  # P-25: sobre una entrada ya lista no cambia nada y vuelve al detalle.
  # La autorización de escritura se decide antes, en load_entry.
  def mark_ready
    load_entry
    return redirect_to(feedback_entry_path(@entry)) if @entry.ready?

    if @entry.mark_ready
      redirect_to feedback_entry_path(@entry), notice: "La entrada está lista y sigue siendo privada: solo vos podés verla."
    else
      render :show, status: :unprocessable_content
    end
  end

  private
    def load_entry
      @entry = policy_scope(FeedbackEntry).includes(:person, :author).find(params[:id])
      authorize @entry
      # Un solo predicado decide la variante del detalle (P-24): si la cuenta
      # todavía puede escribir, la persona está en su alcance de personas.
      @writable = policy(@entry).update?
    end

    def capture_params
      params.expect(feedback_entry: [ :context ])
    end

    # GL-15: los campos de la entrada y el estado del botón elegido; sin autor
    # ni persona.
    def complete_params
      params.expect(feedback_entry: %i[ occurred_on context signal dimension evidence impact confidence status ])
    end

    # Sin autor, persona ni estado: no se cambian por la edición.
    def entry_params
      params.expect(feedback_entry: %i[ occurred_on context signal dimension evidence impact confidence ])
    end
end
