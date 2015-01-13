class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(:email => user_params[:email])
    if user && user.authenticate(user_params[:password])
      session[:user_id] = user.id
      redirect_to params[:redirect_url]
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
