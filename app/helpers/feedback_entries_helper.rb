# Textos de las entradas (GL-06). Los estados dicen siempre «solo vos»:
# «lista» no significa compartida (RN-2). Ningún texto dice «Publicar».
module FeedbackEntriesHelper
  STATUS_LABELS = {
    "draft" => "Borrador · solo vos",
    "ready" => "Lista · solo vos"
  }.freeze

  NOT_SET = "Sin indicar".freeze

  def entry_status_label(entry)
    STATUS_LABELS.fetch(entry.status)
  end

  # En la cronología de la ficha (GL-07, P-10), el borrador avisa además que
  # no cuenta en el resumen.
  def timeline_status_label(entry)
    entry.draft? ? "#{STATUS_LABELS.fetch("draft")} · fuera del resumen" : entry_status_label(entry)
  end

  def entry_date(date)
    date&.strftime("%d/%m/%Y")
  end

  def entry_value(value)
    value.presence || NOT_SET
  end

  # Errores de un campo, junto al campo.
  def entry_field_errors(entry, attribute)
    messages = entry.errors.messages_for(attribute)
    return if messages.empty?

    tag.p(messages.to_sentence, class: "field-error", id: "#{attribute}-error")
  end

  # Resumen de errores, arriba del formulario o del detalle.
  def entry_error_summary(entry)
    return if entry.errors.empty?

    tag.div(class: "error-summary", role: "alert") do
      tag.ul { safe_join(entry.errors.map(&:message).uniq.map { |message| tag.li(message) }) }
    end
  end
end
