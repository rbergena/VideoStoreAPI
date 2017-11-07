require "test_helper"

describe RentalsController do


  describe "create" do
    let(:rental_data) {
      {
        movie_id: Movie.first.id,
        customer_id: Customer.first.id,
        due_date: DateTime.now
      }
    }

    it "creates a rental" do
      Rental.new(rental_data).must_be :valid?

      proc {
        post checkout_path, params: rental_data
      }.must_change 'Rental.count', 1

      must_respond_with :success
    end

    it "responds with bad_request if invalid data" do
      invalid_rental_data = {
        customer_id: Customer.first.id,
        due_date: DateTime.now
      }

      proc {
        post checkout_path, params: invalid_rental_data
      }.wont_change 'Rental.count'
      must_respond_with :bad_request

      body = JSON.parse(response.body)
      body.must_equal "errors" => {"movie" => ["must exist"]}
    end
  end
end
