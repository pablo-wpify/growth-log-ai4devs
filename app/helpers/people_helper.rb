module PeopleHelper
  # Rol y equipo en una línea; si falta uno, lo indica (GL-05, P-17).
  def person_role_and_team(person)
    [ person.role.presence || "Sin rol indicado", person.team.presence || "Sin equipo indicado" ].join(" · ")
  end

  # Conteo de entradas propias listas (GL-07, 1.15 parcial).
  def ready_entries_count(count)
    count == 1 ? "1 entrada lista" : "#{count} entradas listas"
  end
end
