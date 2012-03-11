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
end
