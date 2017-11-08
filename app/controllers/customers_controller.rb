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

  def current
    checked_out(:current)
  end

  def history
    checked_out(:history)
  end

private

  def checked_out(status)
    customer = Customer.find_by(id: params[:id])
    checked_out = customer.checked_out(status)

    unless checked_out.empty?
      render(
        json: checked_out,
        status: :ok
      )
    else
      render(
        json: { errors: {
          records: ["No records found."]}
          },
        status: :not_found
      )
    end
  end

end
