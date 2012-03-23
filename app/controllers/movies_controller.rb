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
      imdbid = params[:id]
      Movie.create(:imdbid => imdbid)
      if current_user.like(Movie.find_by_imdbid(imdbid).id).invalid?
        flash[:success] = "You have already liked this movie!"
      else
        flash[:success] = "You have successfully liked this movie."
      end
      redirect_to '/movies/' + imdbid
    else
      redirect_to signin_path
    end
  end
end
