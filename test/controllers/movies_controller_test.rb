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
      must_respond_with :not_found

      body = JSON.parse(response.body)
      body["errors"].must_include "movies"
    end

    it "returns the correct information" do
      get movies_path
      body = JSON.parse(response.body)

      body.each do |movie|
        movie.keys.sort.must_equal ["id", "release_date", "title"]
      end
    end
  end

  describe "show" do
    it "returns a hash of information for one movie" do
      get movie_path(movies(:jaws).id)
      must_respond_with :success

      body = JSON.parse(response.body)
      body.must_be_kind_of Hash
      body["title"].must_equal movies(:jaws).title
    end

    it "returns not_found when movie doesn't exist" do
      get movie_path(Movie.last.id + 1)
      must_respond_with :not_found

      body = JSON.parse(response.body)
      body.must_equal "errors"=>{"id"=>["Movie with id 673001845 not found"]}
    end

    it "returns the correct information" do
      get movie_path(movies(:jaws).id)
      body = JSON.parse(response.body)

      body.keys.sort.must_equal ["available_inventory", "inventory", "overview", "release_date", "title"]
    end
  end

  describe "create" do
    let(:movie_data) {
      {
        title: "Pirates of the Caribbean",
        overview: "great movie with pirates",
        release_date: "2001-05-09",
        inventory: 3
      }
    }

    it "creates a movie" do
      proc {
        post movies_path, params: movie_data
      }.must_change 'Movie.count', 1
      must_respond_with :success
    end

    it "responds with bad_request if invalid data" do
      movie_data[:inventory] = nil
      proc {
        post movies_path, params: movie_data
      }.wont_change 'Movie.count'
      must_respond_with :bad_request

      body = JSON.parse(response.body)
      body.must_equal "errors" => {"inventory" => ["is not a number"]}
    end
  end

  describe "current" do
    it "returns an array of current rentals for one movie" do
      get current_rentals_movie_path(movies(:jaws).id)
      must_respond_with :success

      body = JSON.parse(response.body)
      body.must_be_kind_of Array
      body[0]["customer_id"].must_equal rentals(:rental_two).customer_id
    end

    it "returns not_found when no rentals exist" do
      get current_rentals_movie_path(movies(:lambs).id)
      must_respond_with :not_found

      body = JSON.parse(response.body)
      body.must_equal "errors"=>{"records"=>["No records found."]}
    end

    it "returns the correct information" do
      get current_rentals_movie_path(movies(:jaws).id)
      body = JSON.parse(response.body)

      body[0].keys.sort.must_equal ["checkout_date", "customer_id", "due_date", "name", "postal_code"]
    end
  end

  describe "history" do
    it "returns an array of historic rentals for one movie" do
      get historic_rentals_movie_path(movies(:jaws).id)
      must_respond_with :success

      body = JSON.parse(response.body)
      body.must_be_kind_of Array
      body[0]["customer_id"].must_equal rentals(:rental_three).customer_id
    end

    it "returns not_found when movie doesn't exist" do
      get historic_rentals_movie_path(movies(:lambs).id)
      must_respond_with :not_found

      body = JSON.parse(response.body)
      body.must_equal "errors"=>{"records"=>["No records found."]}
    end

    it "returns the correct information" do
      get historic_rentals_movie_path(movies(:jaws).id)
      body = JSON.parse(response.body)

      body[0].keys.sort.must_equal ["checkout_date", "customer_id", "due_date", "name", "postal_code"]
    end
  end
end
