class UsersController < ApplicationController
  def create
    user = User.create params[:user]
    render :json => {:status => 'ok', :user_id => user.id}
  end

  def show
    user = User.find params[:id]
    render :json => user
  end
end
