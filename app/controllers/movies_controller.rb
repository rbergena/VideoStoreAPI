class MoviesController < ApplicationController

  def index
    movies = Movie.all

    render(
      json: movies.as_json(only: [:id, :title, :release_date]),
      status: :ok
    )
  end


end
