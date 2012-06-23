class MailsController < ApplicationController
  before_filter :find_user

  def index
    render :json => @user.mails
  end

  def create
    encrypted = params[:encrypted]
    mail = Mail.new params[:mail]
    if encrypted
      mail.user = @user
      mail.save
    else
      Mail.receive_mail @user, mail 
    end
    render :json => {:status => 'ok'}
  end

  private
  def find_user
    @user = User.find params[:user_id]
    if not @user
      render :json => {:message => 'User not found.'}, :status => 404
    end
  end
end
