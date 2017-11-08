class MoviesController < ApplicationController

  def index
    movies = Movie.all

    unless movies.empty?
      render(
        json: movies.as_json(only: [:id, :title, :release_date]),
        status: :ok
      )
    else
      render(
        json: { errors: {
          movies: ["No movies found."]}
          },
        status: :not_found
      )
    end
  end

  def show
    movie = Movie.find_by(id: params[:id])

    if movie
      render(
        json: movie.as_json(only: [:available_inventory, :title, :overview, :inventory, :release_date]),
        status: :ok
      )
    else
      render(
        json: { errors: {
          id: ["Movie with id #{params[:id]} not found"]}
          },
        status: :not_found
      )
    end
  end

  def create
    movie = Movie.new(movie_params)

    if movie.save
      render(
        json: { id: movie.id },
        status: :ok
      )
    else
      render(
        json: { errors: movie.errors.messages },
        status: :bad_request
      )
    end
  end

  def current
    checked_out(:current)
  end

  def history
    checked_out(:history)
  end

private
  def movie_params
    params.permit(:title, :overview, :release_date, :inventory)
  end

  def checked_out(status)
    movie = Movie.find_by(id: params[:id])
    checked_out = movie.checked_out(status)

    unless checked_out.empty?
      render(
        json: checked_out,
        status: :ok
      )
    else
      render(
        json: { errors: {
          records: ["No records found."]}
          },
        status: :not_found
      )
    end
  end

end
