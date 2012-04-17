class PagesController < ApplicationController
  before_filter :authenticate, :only => [:newsfeed]
  def home
    if signed_in?
      redirect_to feed_path
    else
      @title = "Home"
    end
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end
  

  def help
    @title = "Help"
  end

  def permission
    @title = "Denied"
  end

  def newsfeed
    @title = "News Feed"
    following = current_user.following
    @recentActivity = []
    following.each do |user|
      user.likes.where("updated_at >= '#{Time.now.utc.prev_month}'").each do |like|
        if like.watch_list == true and like.like_list == false
          tempMovie = Movie.find(like.movie_id)
          @recentActivity << {'user' => user.name, 'user_id' => user.id, 'title' => tempMovie.title, 'imdbid' => tempMovie.imdbid, 'list' => "watch", 'created_at' => like.updated_at.in_time_zone('Central Time (US & Canada)')}
        end
        if like.watch_list == false and like.like_list == true
          tempMovie = Movie.find(like.movie_id)
          @recentActivity << {'user' => user.name, 'user_id' => user.id, 'title' => tempMovie.title, 'imdbid' => tempMovie.imdbid, 'list' => "like", 'created_at' => like.updated_at.in_time_zone('Central Time (US & Canada)')}
        end
      end
      user.relationships.where("created_at >= '#{Time.now.utc.prev_month}'").each do |relationship|
        tempUser = User.find(relationship.followed_id)
        if tempUser != current_user
          @recentActivity << {'user' => user.name, 'user_id' => user.id, 'following_id' => tempUser.id,'following' => tempUser.name, 'created_at' => relationship.created_at.in_time_zone('Central Time (US & Canada)')}
        end
      end
    end
    Relationship.where("created_at >= '#{Time.now.utc.prev_month}' and followed_id = '#{current_user.id}'").each do |relationship|
      tempUser = User.find(relationship.follower_id)
      @recentActivity << {'user' => tempUser.name, 'user_id' => tempUser.id, 'following_id' => current_user.id,'following' => "you", 'created_at' => relationship.created_at.in_time_zone('Central Time (US & Canada)')}
    end
    @recentActivity = (@recentActivity.sort {|a,b| b['created_at'] <=> a['created_at']}).paginate(:page => params[:page], :per_page => 10)
  end
  private

  def authenticate
    deny_access unless signed_in?
  end
end
