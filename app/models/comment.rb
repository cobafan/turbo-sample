class Comment < ApplicationRecord
  belongs_to :todo

  validates :content, presence: true
  validates :author, presence: true

  broadcasts_to :todo
end
