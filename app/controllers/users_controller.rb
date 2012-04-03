class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update, :index, :destroy, :results, :following, :followers, :suggestions]
  before_filter :correct_user, :only => [:edit, :update, :destroy, :suggestions]
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
  
  def suggestions
    @user = User.find(params[:id])
    @title = "My Suggestions"
    genres1 = @user.movies.select("genre1").collect {|x| x.genre1}
    genres2 = @user.movies.select("genre2").collect {|x| x.genre2}
    genres = genres1 + genres2
    freq = genres.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
    genres = genres.sort_by { |v| freq[v] }.reverse.uniq
    @first = genres.first
    @second = genres.second
    alreadySeen = @user.movies
    @movies = Movie.where("((genre1 = '#{@first}' OR genre2 = '#{@first}') AND user_rating >= 6.5) OR ((genre1 = '#{@second}' OR genre2 = '#{@second}') AND user_rating >= 7)").order("user_rating DESC")    
    @movies = @movies - alreadySeen
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
    @likes = @user.movies.where(:likes => {:like_list => true}).order("likes.created_at DESC").limit(10)
    @watch_list = @user.movies.where(:likes => {:watch_list => true}).order("likes.created_at DESC").limit(10)
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

  def authenticate
    deny_access unless signed_in?
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(permission_path) unless current_user?(@user)
    
  end

end
