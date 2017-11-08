class Rental < ApplicationRecord
  belongs_to :movie
  belongs_to :customer

  after_create :set_checkout_date

  def set_checkout_date
    self.update_columns(checkout_date: self.created_at)
  end

end
