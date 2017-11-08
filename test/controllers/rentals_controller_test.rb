require "test_helper"

describe RentalsController do


  describe "checkout" do
    let(:rental_data) {
      {
        movie_id: Movie.first.id,
        customer_id: Customer.first.id,
        due_date: DateTime.now
      }
    }

    it "creates a rental" do
      rental = Rental.new(rental_data)
      rental.must_be :valid?

      proc {
        post checkout_path, params: rental_data
      }.must_change 'Rental.count', 1

      Rental.last.customer.id.must_equal rental.customer.id
      # checkout_date.must_equal Date.today

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

  describe "checkin" do

    it "updates a rental with checkin_date" do
      rental_params = {
        customer_id: Customer.first.id,
        movie_id: Movie.first.id,
        checkin_date: nil
      }

      rental = Rental.where(rental_params).first

      # puts rental.inspect

      post checkin_path, params: rental_params

      rental.reload.checkin_date.must_equal Date.today


      # proc {
      # }.must_change 'Rental.count', 1

      must_respond_with :success
    end


  end

end
