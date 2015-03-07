class User < ActiveRecord::Base
	has_many :playlist, dependent: :destroy

	def self.create_user(username, password, password_confirm)
		return false if password != password_confirm
		return false if User.where(username: username).to_a.size > 0

		salt = BCrypt::Engine.generate_salt
		hashed_password = BCrypt::Engine.hash_secret(password, salt)
		new_user = User.create(username: username, password: hashed_password, salt: salt)
		new_user
	end

	def self.authenticate(username, password)
		user = User.where(username: username).first
		if user.present? && user.password == BCrypt::Engine.hash_secret(password, user.salt)
			user
		else
			nil
		end
	end

	def self.get_library_id(user)
		user_library = Playlist.where(name: "default" + user.username + user.salt + user.id.to_s).first
		if !user_library.present?
		  	user_library = Playlist.create_playlist("default" + user.username + user.salt + user.id.to_s, user.id)
		  	user_library.save
		end
		return user_library.id
	end
end
