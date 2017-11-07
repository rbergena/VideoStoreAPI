class Movie < ApplicationRecord
  has_many :rentals
  # has_many :customers, through: :rentals

  validates :title, presence: true
  validates :inventory, numericality: { greater_than: 0 }

  # scope :current, -> { where(checkin_date: nil) }
  #is there a way to do scope for a specific instance?

  # attribute :available_inventory, :integer, default: :inventory

  after_create :set_avail_inv_attribute

  def set_avail_inv_attribute
    self.update_columns(available_inventory: self.inventory) if available_inventory.nil?
  end

  def current
    current = []
    self.rentals.each do |rental|
      if rental.checkin_date == nil
        current << rental
      end
    end
  end


end
