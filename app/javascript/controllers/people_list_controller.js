import { Controller } from "@hotwired/stimulus"

// Búsqueda, filtro y orden del listado «Personas» (GL-14, P-49 a P-51).
// Trabaja solo sobre las filas que el servidor ya mostró con el alcance de
// la cuenta: no pide datos, no toca la URL y no guarda estado. Al cargar,
// muestra los controles (sin JavaScript quedan ocultos) y los deja en sus
// valores iniciales, también si el navegador intenta restaurarlos.
export default class extends Controller {
  static targets = ["controls", "query", "team", "order", "clear", "list", "row", "noResults"]

  connect() {
    this.queryTarget.value = ""
    this.teamTarget.value = ""
    this.orderTarget.value = "name"
    this.controlsTarget.hidden = false
    this.apply()
  }

  apply() {
    const query = normalize(this.queryTarget.value.trim())
    const team = this.teamTarget.value
    const noTeam = this.teamTarget.dataset.noTeam

    let visible = 0
    this.sortedRows().forEach((row) => {
      const matchesQuery = query === "" || row.dataset.searchName.includes(query)
      const matchesTeam = team === "" || (team === noTeam ? row.dataset.team === "" : row.dataset.team === team)
      row.hidden = !(matchesQuery && matchesTeam)
      if (!row.hidden) visible += 1
      this.listTarget.appendChild(row)
    })

    this.clearTarget.hidden = query === "" && team === ""
    this.noResultsTarget.hidden = visible > 0
    this.listTarget.hidden = visible === 0
  }

  // «Limpiar filtros» (P-48): vacía la búsqueda y el filtro, y conserva el orden.
  clear() {
    this.queryTarget.value = ""
    this.teamTarget.value = ""
    this.apply()
    this.queryTarget.focus()
  }

  // «Nombre» respeta el orden del servidor (nombre e identificador, 1.14).
  // «Hechos más recientes» (P-44, P-47) va de la fecha más reciente a la más
  // antigua; las personas sin entradas listas visibles van al final, y los
  // empates se resuelven con el orden del servidor.
  sortedRows() {
    const position = (row) => Number(row.dataset.position)
    const rows = [...this.rowTargets]
    if (this.orderTarget.value !== "recent") return rows.sort((a, b) => position(a) - position(b))

    return rows.sort((a, b) => {
      const dateA = a.dataset.lastFact
      const dateB = b.dataset.lastFact
      if (dateA !== dateB) {
        if (dateA === "") return 1
        if (dateB === "") return -1
        return dateA < dateB ? 1 : -1
      }
      return position(a) - position(b)
    })
  }
}

function normalize(text) {
  return text.normalize("NFD").replace(/\p{Mn}/gu, "").toLowerCase()
}
