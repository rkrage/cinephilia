class RelationshipsController < ApplicationController
  before_filter :authenticate
  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    flash[:message] = "You are now following '" + @user.name + "'!"
    redirect_to following_user_path(current_user)
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    flash[:message] = "You are no longer following '" + @user.name + "'."
    redirect_to current_user
  end

  def authenticate
    deny_access unless signed_in?
  end

end
