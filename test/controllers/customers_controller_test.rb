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
      body.length.must_equal Customer.count+1
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

end
