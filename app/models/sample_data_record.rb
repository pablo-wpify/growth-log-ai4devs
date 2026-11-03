# Marca de un registro creado por la tarea de datos ficticios (GL-08, P-13).
# Las restricciones viven en la base: clave única, exactamente una
# referencia, prefijo coherente y sin marcas huérfanas.
class SampleDataRecord < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :person, optional: true
  belongs_to :assignment, optional: true
end
