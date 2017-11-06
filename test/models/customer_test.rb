require "test_helper"

describe Customer do
  let(:customer) { Customer.new }

  it "must be valid" do
    value(customer).must_be :valid?
  end

  # at least one positive and one negative test case for each relation, validation, and custom function

  
end
