require "test_helper"

describe Movie do
  describe "validations" do
    before do
      @movie_params = {
        overview: "this is an overview",
        release_date: "some date"
      }
    end
    it "works when the right things are there" do
      movie = movies(:psycho)
      movie.must_be :valid?
    end

    it "wont save if there is no name" do
      movie = Movie.new(@movie_params)
      movie.wont_be :valid?
      movie.errors.messages.must_include :title
    end

    it "wont save if there is no inventory" do
      movie = Movie.new(@movie_params)
      movie.wont_be :valid?
      movie.errors.messages.must_include :inventory
    end

    it "must have an inventory greater_than 0" do
      @movie_params[:inventory] = -12
      movie = Movie.new(@movie_params)
      movie.wont_be :valid?
      movie.errors.messages.must_include :inventory
    end
  end

end
