# Persona acompañada (GL-03). Su estado activo es independiente de sus
# asignaciones y de las cuentas de sus líderes (P-9).
class Person < ApplicationRecord
  has_many :assignments, dependent: :restrict_with_exception
  has_many :feedback_entries, dependent: :restrict_with_exception

  validates :name, presence: true

  scope :active, -> { where(active: true) }
end
