class Customer < ApplicationRecord
  has_many :rentals
  # has_many :movies, through: :rentals


  validates :name, presence: true

  def checked_out(status)
    checked_out = []
    self.rentals.each do |rental|
      if (status == :current && rental.checkin_date == nil) || (status == :history && rental.checkin_date)
        info = {
          checkout_date: rental.checkout_date,
          due_date: rental.due_date,
          title: rental.movie.title,
        }
        checked_out << info
      end
    end
    return checked_out
  end

end
