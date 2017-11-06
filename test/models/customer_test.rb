require "test_helper"

describe Customer do


  describe "validations" do

    it "wont save if name is not present" do
      invalid_customer_data = {
        phone: "(555)555-555"
      }

      invalid_customer = Customer.new(invalid_customer_data)
      invalid_customer.wont_be :valid?
      invalid_customer.errors.messages.must_include :name
      invalid_customer.errors.messages.values.first.must_include "can't be blank"
    end

    it "will save if name is present" do
      valid_customer_data = {
        name: "test",
        phone: "(555)555-555"
      }

      start_count = Customer.count

      valid_customer = Customer.new(valid_customer_data)
      valid_customer.must_be :valid?
      valid_customer.save

      Customer.count.must_equal start_count+1
    end

    it "will default movies_checked_out_count to 0" do
      valid_customer_data = {
        name: "test",
        phone: "(555)555-555"
      }

      valid_customer = Customer.new(valid_customer_data)
      valid_customer.save

      valid_customer.movies_checked_out_count.must_equal 0
    end

    it "will change movies_checked_out_count if provided" do
      valid_customer_data = {
        name: "test",
        phone: "(555)555-555",
        movies_checked_out_count: 3
      }

      valid_customer = Customer.new(valid_customer_data)
      valid_customer.save

      valid_customer.movies_checked_out_count.must_equal 3
    end
  end

end
