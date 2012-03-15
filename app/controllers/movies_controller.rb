class MoviesController < ApplicationController  
  def results
    @title = "Results"
    @query = params[:q]
    @movies = Imdb::Search.new(@query).movies
    @length = @movies.length - 1
    if @length > 9
      @length = 9
    end
  end

  def like
    if signed_in?
      flash[:success] = "We acknowledge the fact that you are trying to like the movie with id: " + params[:id]
      @movie = Imdb::Movie.new(params[:id])
      redirect_to current_user
    else
      redirect_to signin_path
    end
  end
end
