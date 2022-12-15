class Api::V1::MoviesController < ApplicationController
  before_action :set_movie, only: %i[show update destroy]

  def index
    @movies = Movie.all
    render json: @movies.to_json(only: %i[name review year director image_url]), status: 200
  end

  def show
    if @movie
      render json: @movie.to_json(only: %i[name review year director image_url]), status: 200
    else
      render json: { status: 404, message: 'Not Found' }, status: 404
    end
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      render json: @movie, status: 201
    else
      render json: { status: 422, message: 'Error creating movie' }, status: :unprocesable_entity
    end
  end

  def update
    if @movie
      if @movie.update(movie_params)
        render json: { status: 200, message: 'Updated correctly' }, status: 200
      else
        render json: { message: 'Error updating, please try again' }, status: :unprocesable_entity
      end
    else
      render json: { status: 404, message: 'Not Found' }, status: 404
    end
  end

  def destroy
    if @movie
      @movie.destroy
      render json: { message: 'Movie deleted' }, status: 200
    else
      render json: { status: 404, message: 'Not Found' }, status: 404
    end
  end

  private

  def movie_params
    params.require(:movie).permit(:name, :review, :year, :director, :image_url)
  end

  def set_movie
    @movie = Movie.find_by_id(params[:id])
  end

end
