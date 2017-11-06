class MoviesController < ApplicationController

  def index
    movies = Movie.all

    render json: movies.as_json
  end


end
