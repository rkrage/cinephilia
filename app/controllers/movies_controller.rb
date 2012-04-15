class MoviesController < ApplicationController
  before_filter :authenticate, :only => [:like]
  def results
    @title = "Movie Results"
    @query = params[:q]
    @movies = Imdb::Search.new(@query).movies
    @length = @movies.length - 1
    if @length > 9
    @length = 9
    end
  end

  def index
    @title = "All Movies By Name"
    @movies = Movie.paginate(:page => params[:page], :per_page => 10, :order => 'title')
    @someBool = true
    render 'show_movies'
  end

  def show
    @movie = Movie.find_by_imdbid(params[:id])
    if @movie.nil?
      @movie = Movie.create(:imdbid => params[:id])
    end
    @title = @movie.title
  end

  def sort_by_rating
    @title = "All Movies By Rating"
    @movies = Movie.paginate(:page => params[:page], :per_page => 10, :order => 'user_rating DESC')
    @someBool = false
    render 'show_movies'
  end

  def like
    imdbid = params[:id]
    watch_list = params[:watch_list] == "yes"
    succes = nil
    failure = nil
    Movie.create(:imdbid => imdbid)
    movie = Movie.find_by_imdbid(imdbid)
    title = movie.title
      success1 = "You have successfully added '" + title + "' to your watch list."
      failure1 = "'" + title + "'  is already in your watch list!"
      success2 = "You have successfully liked '" + title + "'."
      failure2 = "You have already liked '" + title + "'!"
    temp = current_user.like(movie.id)
    if temp.invalid?
      temp = current_user.likes.find_by_movie_id(movie.id)
      if temp.watch_list and watch_list
        flash[:failure] = failure1
      elsif !(watch_list) and temp.like_list
        flash[:failure] = failure2
      elsif watch_list
        temp.watch_list = true
        temp.save
        flash[:success] = success1
      else
        temp.like_list = true
        temp.save
        flash[:success] = success2
      end
    else
      temp.watch_list = watch_list
      temp.like_list = !watch_list
      temp.save
      if watch_list
        flash[:success] = success1
      else
        flash[:success] = success2
      end
    end
    redirect_to current_user
  end
  private

  def authenticate
    deny_access unless signed_in?
  end
end
