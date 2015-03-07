class ApplicationController < ActionController::Base

	before_action :require_authentication
  skip_before_action :require_authentication, only: [:index]
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  	def index
  		if session[:user_id]
  			@user_id = session[:user_id]
  			@username = session[:username]
        redirect_to '/dashboard'
  		end
  	end


  	private

  	def require_authentication
  		if session[:user_id] == nil
  			redirect_to '/login'
  		end
  	end
end
