class CustomersController < ApplicationController

  def index
    customers = Customer.all

    unless customers.empty?
      render(
        json: customers.as_json(only: [:id, :name, :registered_at, :postal_code, :phone, :movies_checked_out_count]),
        status: :ok
      )
    else
      render(
        json: { errors: {
          customers: ["No customers found."]}
        },
        status: :not_found
      )
    end

  end

end
