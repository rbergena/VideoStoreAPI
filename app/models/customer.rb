class Customer < ApplicationRecord
  has_many :movies
  
  validates :name, presence: true

end
