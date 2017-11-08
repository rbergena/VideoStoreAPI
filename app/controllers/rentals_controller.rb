class RentalsController < ApplicationController

  def overdue
  end

  def checkout
    rental = Rental.new(rental_params)

    # if rental.movie.available_inventory
    if rental.save
      render(
        json: {
          customer_id: rental.customer_id,
          movie_id: rental.movie_id,
          due_date: rental.due_date
        },
        status: :ok
      )
      rental.customer.movies_checked_out_count +=1
      rental.movie.available_inventory -= 1
      # binding.pry

    else
      render(
        json: { errors: rental.errors.messages },
        status: :bad_request
      )
    end
    # else

    #some error movie not available
    # end

    # binding.pry
    # movie has many rentals in movie movie.rentals
    # rental.customer.movies_checked_out_count +=1
    # rental.customer.movies_checked_out_count
    # rental.movie.inspect
    # rental.movie.available_inventory -= 1
    # puts rental.customer.movies_checked_out_count
  end

  def checkin
    rental = Rental.where(rental_params).first

    if rental
      rental.checkin_date = DateTime.now
      rental.due_date = nil
      rental.save

      rental.customer.movies_checked_out_count -=1
      rental.movie.available_inventory += 1
    else
      render(
        json: { errors: rental.errors.messages },
        status: :bad_request
      )
    end
  end

  def rental_params
    params.permit(:customer_id, :movie_id, :due_date, :checkin_date)
  end
end
