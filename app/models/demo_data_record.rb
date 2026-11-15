# Marca de un registro creado por la tarea de datos demo (GL-10, P-31). Las
# restricciones viven en la base: clave única, exactamente una referencia,
# prefijo coherente y sin marcas huérfanas.
class DemoDataRecord < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :person, optional: true
  belongs_to :assignment, optional: true
  belongs_to :feedback_entry, optional: true
end
