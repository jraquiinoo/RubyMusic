class AccountController < ApplicationController
	protect_from_forgery with: :exception
	skip_before_action :require_authentication, only: [:login, :signup, :login_user, :signup_user]


	def login_user
		user = User.authenticate(params[:username], params[:password])
		if user.present?
			session[:user_id] = user.id
			render :json => {:status => 0, :user_id => user.id, :username => user.username}
		else
			render :json => {:status => 1, :error => "invalid username or password"}
		end
	end

	def signup_user
		new_user = User.create_user(params[:username], params[:password], params[:repassword])
		if new_user.present?
			session[:user_id] = new_user.id
			render :json => {:status => 0, :user_id => new_user.id, :username => new_user.username}
		else
			render :json => {:status => 1, :error => "username already exists"}
		end
	end

	def login
		check_authentication
	end

	def signup
		check_authentication
	end

	def logout
		session[:user_id] = nil
		redirect_to '/'
	end

	private

	def check_authentication
		if session[:user_id]
			@user_id = session[:user_id]
			@username = session[:username]
			redirect_to '/'
		end
	end
end
