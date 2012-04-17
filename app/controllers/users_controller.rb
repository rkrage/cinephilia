class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update, :index, :destroy, :results, :following, :followers, :user_suggestions, :movie_suggestions]
  before_filter :correct_user, :only => [:edit, :update, :destroy, :user_suggestions, :movie_suggestions]
  def new
    if signed_in?
      redirect_to root_path
    else
      @user = User.new
      @title = "Sign up"
    end
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end

  def watch_list
    @user = User.find(params[:id])
    @title = @user.name + " Watch List"
    @movies = @user.movies.where(:likes => {:watch_list => true}).paginate(:page => params[:page], :per_page => 20, :order => 'title')
  end

  def like_list
    @user = User.find(params[:id])
    @title = @user.name + " Like List"
    @movies = @user.movies.where(:likes => {:like_list => true}).paginate(:page => params[:page], :per_page => 20, :order => 'title')
  end

  def movie_suggestions
    @user = User.find(params[:id])
    @title = "My Suggestions"
    genres = get_genres(@user)
    @first = genres.first
    @second = genres.second
    if @second.nil?
    @second = @first
    end
    @movies = nil
    if !@first.nil?
      alreadySeen = @user.movies
      @movies = Movie.where("((genre1 = '#{@first}' OR genre2 = '#{@first}') AND user_rating >= '6.5') OR ((genre1 = '#{@second}' OR genre2 = '#{@second}') AND user_rating >= '7')").order("user_rating DESC")
      followers = @user.followers
      follower_movies = []
      followers.each do |follower|
        follower_movies = follower_movies + follower.movies.where("user_rating >= '5'")
      end
      follower_movies = follower_movies.uniq.sort {|a,b| b.user_rating <=> a.user_rating}
      @movies = (@movies + follower_movies - alreadySeen).uniq.paginate(:page => params[:page], :per_page => 20)
    end
  end

  def user_suggestions
    @user = User.find(params[:id])
    @title = "User Suggestions"
    genres = get_genres(@user)
    @first = genres.first
    @second = genres.second
    if @second.nil?
      @second = @first
    end
    @users2 = []
    if !@first.nil?
      temp_g1 = nil
      temp_g2 = nil
      temp_genres = nil
      User.all.each do |temp_user|
        temp_genres = get_genres(temp_user)
        temp_g1 = temp_genres.first
        temp_g2 = temp_genres.second
        if temp_g2.nil?
          temp_g2 = temp_g1
        end
        if !temp_g1.nil?

          if ((temp_user != @user) and ((temp_g1.to_s == @first.to_s) or (temp_g1.to_s == @second.to_s) or (temp_g2.to_s == @first.to_s) or (temp_g2.to_s == @second.to_s)))
            @users2 << temp_user
          end
        end
      end
      @users2 = (@users2 - @user.following).sort {|a,b| b.followers.length <=> a.followers.length}
      @users2 = @users2.paginate(:page => params[:page], :per_page => 10)
    end
  end

  def results
    @title = "User Results"
    @query = params[:q]
    @users = User.find_with_index(@query)
    @length = @users.length - 1
    if @length > 9
    @length = 9
    end
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
    @likes = @user.movies.where(:likes => {:like_list => true}).order("likes.updated_at DESC").limit(10)
    @watch_list = @user.movies.where(:likes => {:watch_list => true}).order("likes.updated_at DESC").limit(10)
  end

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page], :per_page => 10, :order => 'name')
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Cinephilia!"
      redirect_to @user
    else
      @title = "Sign up"
      render 'new'
    end
  end

  def edit
    @title = "Edit user"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to root_path
  end
  private

  def get_genres(user)
    genres1 = user.movies.select("genre1").collect {|x| x.genre1}.compact
    genres2 = user.movies.select("genre2").collect {|x| x.genre2}.compact
    genres = genres1 + genres2
    freq = genres.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
    genres = genres.sort_by { |v| freq[v] }.reverse.uniq
    return genres
  end

  def authenticate
    deny_access unless signed_in?
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(permission_path) unless current_user?(@user)

  end

end
