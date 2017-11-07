class Movie < ApplicationRecord
  has_many :rentals
  has_many :customers, through: :rentals

  validates :title, presence: true
  validates :inventory, numericality: { greater_than: 0 }

  # attribute :available_inventory, :integer, default: :inventory

  after_create :set_avail_inv_attribute

  def set_avail_inv_attribute
    self.update_columns(available_inventory: self.inventory) if available_inventory.nil?
  end


end
