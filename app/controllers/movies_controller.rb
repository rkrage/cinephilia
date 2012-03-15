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
      if Movie.where(:imdbid => params[:id]).empty?
        @movie = Imdb::Movie.new(params[:id])
        @dbmovie = Movie.new
        @dbmovie.imdbid = params[:id]
        @dbmovie.title = @movie.title
        @dbmovie.year = @movie.year
        @length = @movie.genres.length
        if @length < 3
          @dbmovie.genre1 = @movie.genres[0]
          @dbmovie.genre2 = @movie.genres[1]
        else
          @fst = rand(@length)
          @snd = rand(@length)
          while @snd == @fst
            @snd = rand(@length)
          end
          @dbmovie.genre1 = @movie.genres[@fst]
          @dbmovie.genre2 = @movie.genres[@snd]
        end
        @rating = @movie.mpaa_rating
        if !(@rating.nil?)
          @rating = @rating.split[1]
        end
        @dbmovie.rating = @rating
        @dbmovie.save
        redirect_to current_user
      else
        redirect_to current_user
      end
    else
      redirect_to signin_path
    end
  end
end
