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

  describe "custom methods" do
    describe "set_avail_inv_attribute" do
      it "does what its supposed to" do
        movie_params = {
          title: "title",
          overview: "this is an overview",
          release_date: "some date",
          inventory: 8,
          available_inventory: nil,
        }

        movie = Movie.new(movie_params)
        movie.must_be :valid?
        movie.available_inventory.must_equal nil

        movie.save
        movie.available_inventory.must_equal 8
      end
    end
    
    describe "checked_out" do
      it "returns an array with rentals" do
        movie = movies(:psycho)
        current = movie.checked_out(:current)
        current.must_be_kind_of Array
        current[0].must_be_kind_of Hash
      end

      it "returns an empty array if nothing status if there are no applicable rentals" do
        movie = movies(:psycho)
        current = movie.checked_out(:history)
        current.must_be_kind_of Array
        current.must_be :empty?
      end
    end
  end

end
