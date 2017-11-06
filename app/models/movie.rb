class Movie < ApplicationRecord

  validates :title, presence: true
  validates :inventory, numericality: { greater_than: 0 }
end
