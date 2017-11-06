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
      body.must_equal "not found" => true
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
        post movies_path, params: {movie: movie_data}
      }.must_change 'Movie.count', 1
      must_respond_with :success
    end

    it "responds with bad_request if invalid data" do
      movie_data[:inventory] = nil
      proc {
        post movies_path, params: {movie: movie_data}
      }.wont_change 'Movie.count'
      must_respond_with :bad_request

      body = JSON.parse(response.body)
      body.must_equal "errors" => {"inventory" => ["is not a number"]}
    end
  end
end
