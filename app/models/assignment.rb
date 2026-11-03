# Asignación de una cuenta líder a una persona (GL-03). Activa mientras no
# tenga fecha de fin. La unicidad por par la garantiza la base (P-8).
class Assignment < ApplicationRecord
  belongs_to :leader, class_name: "User"
  belongs_to :person

  validates :started_at, presence: true

  scope :active, -> { where(ended_at: nil) }
end
