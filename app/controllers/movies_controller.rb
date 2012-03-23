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

  def index
    @title = "All Movies"
    @movies = Movie.paginate(:page => params[:page], :per_page => 10, :order => 'title')
  end

  def show
    @movie = Movie.find_by_imdbid(params[:id])
    if @movie.nil?
      @movie = Movie.create(:imdbid => params[:id])
    end
    @title = @movie.title
  end

  def like
    if signed_in?
      flash[:success] = "We acknowledge the fact that you are trying to like the movie with id: " + params[:id]
      Movie.create(:imdbid => params[:id])
      redirect_to current_user
    else
      redirect_to signin_path
    end
  end
end
