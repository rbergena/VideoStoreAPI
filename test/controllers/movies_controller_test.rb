require "test_helper"

describe MoviesController do
  describe "index" do
    it "returns and array of all Movies" do
      get movies_path
      must_respond_with :success

      body = JSON.parse(response.body)
      body.must_be_kind_of Array
      body.length.must_equal Movie.count
    end

    it  "returns an empty array when no Movies" do
      Movie.destroy_all
      get movies_path
      must_respond_with :success

      body = JSON.parse(response.body)
      body.must_be :empty?
    end

    it "returns the correct information" do
      get movies_path
      body = JSON.parse(response.body)

      body.each do |movie|
        movie.keys.sort.must_equal ["id", "release_date", "title"]
      end
    end
  end
end
