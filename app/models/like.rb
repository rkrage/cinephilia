class Like < ActiveRecord::Base
  attr_accessible :movie_id
  belongs_to :movie
  belongs_to :user
  validates :user_id, :presence => true
  validates :movie_id, :presence => true
  validates_uniqueness_of :user_id, :scope => :movie_id
end
