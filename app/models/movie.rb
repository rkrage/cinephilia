class Movie < ActiveRecord::Base
  attr_accessible :imdbid

  validates :imdbid, :presence => true, :uniqueness => {:case_sensitive => false}

  before_save :create_attrs
  private
  def create_attrs
    movie = Imdb::Movie.new(imdbid)
    self.title = movie.title
    self.year = movie.year
    self.url = movie.url
    self.poster = movie.poster
    self.plot = movie.plot
    length = movie.genres.length
    if length < 3
    self.genre1 = movie.genres[0]
    self.genre2 = movie.genres[1]
    else
      fst = rand(length)
      snd = rand(length)
      while snd == fst
        snd = rand(length)
      end
    self.genre1 = movie.genres[fst]
    self.genre2 = movie.genres[snd]
    end
    rating = movie.mpaa_rating
    if !(rating.nil?)
    rating = rating.split[1]
    end
    self.rating = rating
  end

end
