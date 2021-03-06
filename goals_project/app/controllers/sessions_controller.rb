class SessionsController < ApplicationController
    before_action :require_user!, only: [:destroy]
    before_action :require_no_user!, only: [:new, :create]
   
    def new
        @user = User.new
    end

    def create
        @user = User.find_by_credentials(user_params[:username], user_params[:password])

        if !@user.nil?
            login!(@user)
            redirect_to user_url(@user)
        else
            flash.now[:errors] = "invalid Username or Password"
            render :new
        end
    end

    def destroy
        current_user.reset_session_token!
        session[:session_token] = nil
        redirect_to new_session_url
    end

    private

    def user_params
        params.require(:user).permit(:username, :password)
    end
end