class Todo < ApplicationRecord
  has_many :comments, dependent: :destroy

  validates :title, presence: true

  scope :ordered, -> { order(position: :asc, created_at: :desc) }
  scope :completed, -> { where(completed: true) }
  scope :pending, -> { where(completed: false) }

  broadcasts_to ->(todo) { "todos" }, inserts_by: :prepend
end
