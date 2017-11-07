class RentalsController < ApplicationController

  def overdue
  end

  def checkout
    rental = Rental.new(rental_params)

    if rental.save
      render(
        json: {
          customer_id: rental.customer_id,
          movie_id: rental.movie_id,
          due_date: rental.due_date
        },
        status: :ok
      )
    else
      render(
        json: { errors: rental.errors.messages },
        status: :bad_request
      )
    end
  end

  def checkin

  end

  def rental_params
    params.permit(:customer_id, :movie_id, :due_date)
  end
end
