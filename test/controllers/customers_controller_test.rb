require "test_helper"

describe CustomersController do
  describe "index" do
    it "is a real working route" do
      get customers_path
      must_respond_with :success
    end

    it "returns json" do
      get customers_path
      response.header['Content-Type'].must_include 'json'
    end

    it "returns an Array" do
      get customers_path

      body = JSON.parse(response.body)
      body.must_be_kind_of Array
    end

    it "returns all of the customers" do
      get customers_path

      body = JSON.parse(response.body)
      body.length.must_equal Customer.count
    end

    it "returns an empty array if there are no customers" do
      Customer.destroy_all

      get customers_path

      must_respond_with :success
      body = JSON.parse(response.body)
      body.must_be_kind_of Array

      body.must_be :empty?

    end
  end

  describe "current" do
    it "returns an array of current rentals for one customer" do
      get current_rentals_customer_path(customers(:Shelley).id)
      must_respond_with :success

      body = JSON.parse(response.body)
      body.must_be_kind_of Array
      body[0]["title"].must_equal movies(:psycho).title
    end


    it "returns not_found when no rentals exist" do
      get current_rentals_customer_path(customers(:Curran).id)
      must_respond_with :not_found

      body = JSON.parse(response.body)
      body.must_equal "errors"=>{"records"=>["No records found."]}
    end

    it "returns the correct information" do
      get current_rentals_customer_path(customers(:Shelley).id)
      body = JSON.parse(response.body)

      body[0].keys.sort.must_equal ["checkout_date", "due_date", "title"]
    end
  end

  describe "history" do
    it "returns an array of historic rentals for one movie" do
      get historic_rentals_customer_path(customers(:Shelley).id)
      must_respond_with :success

      body = JSON.parse(response.body)
      body.must_be_kind_of Array
      body[0]["title"].must_equal movies(:jaws).title
    end

    it "returns not_found when movie doesn't exist" do
      get historic_rentals_customer_path(customers(:Curran).id)
      must_respond_with :not_found

      body = JSON.parse(response.body)
      body.must_equal "errors"=>{"records"=>["No records found."]}
    end

    it "returns the correct information" do
      get historic_rentals_customer_path(customers(:Shelley).id)
      body = JSON.parse(response.body)

      body[0].keys.sort.must_equal ["checkout_date", "due_date", "title"]
    end
  end

end
