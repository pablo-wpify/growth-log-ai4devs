module PeopleHelper
  # Rol y equipo en una línea; si falta uno, lo indica (GL-05, P-17).
  def person_role_and_team(person)
    [ person.role.presence || "Sin rol indicado", person.team.presence || "Sin equipo indicado" ].join(" · ")
  end

  # Conteos de la fila (GL-14, P-41 y P-46): entradas listas visibles para la
  # cuenta y borradores propios, en singular con una sola.
  def person_entries_summary(stats)
    return "Sin entradas todavía" if stats.none?

    drafts = stats.drafts.positive? ? pluralize(stats.drafts, "borrador", plural: "borradores") : nil
    ready = stats.ready.positive? ? pluralize(stats.ready, "entrada lista", plural: "entradas listas") : "Sin entradas listas"
    [ ready, drafts ].compact.join(" · ")
  end

  # Fecha del último hecho (GL-14, P-42), con el formato de la cronología.
  def person_last_fact(date)
    "Último hecho: #{date.strftime("%d/%m/%Y")}"
  end

  # Total del listado (GL-14, P-53).
  def people_total(count)
    pluralize(count, "persona que acompañás", plural: "personas que acompañás")
  end

  # Nombre para la búsqueda en el navegador (P-49): sin marcas diacríticas y
  # en minúsculas, igual que normaliza el controlador Stimulus.
  def person_search_name(person)
    person.name.unicode_normalize(:nfd).gsub(/\p{Mn}/, "").downcase
  end

  # Opciones del filtro por equipo (P-43, P-50): solo los equipos de las
  # personas del listado y, si alguna no tiene equipo, «Sin equipo indicado».
  def people_team_options(people)
    teams = people.map { |person| person.team.presence }
    options = [ [ "Todos", "" ] ] + teams.compact.uniq.sort.map { |team| [ team, team ] }
    options << [ "Sin equipo indicado", PeopleHelper::NO_TEAM ] if teams.include?(nil)
    options
  end

  NO_TEAM = "__sin-equipo__".freeze

  def person_team_value(person)
    person.team.presence || ""
  end
end
