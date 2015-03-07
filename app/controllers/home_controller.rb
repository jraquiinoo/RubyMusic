class HomeController < ApplicationController

	def dashboard
		user = User.where(id: session[:user_id]).first;
		if user.present?
			@username = user.username
			
			library_id = User.get_library_id(user)
			@library = Playlist.get_playlist(library_id, user.id, nil)
			@library_size = @library[:tracks].size
			@library[:tracks] = @library[:tracks].take(10)
			@recent = Playlist.get_playlist(library_id, user.id, "created_at DESC")
			@recent[:tracks] = @recent[:tracks].take(6)
			@playlists = Playlist.get_all_playlist(user)
		else 
			session[:user_id] = nil
			redirect_to '/login'
		end
	end

	def upload
		if session[:user_id]
			file = params[:file]
			saved_music_file = MusicFile.save(file, session[:user_id], params[:playlist_id])
			if saved_music_file.present?
				render :json => {status: 0, song: saved_music_file}
			else 
				render :json => {status: 1, error: "File already exists"}
			end
		else
			redirect_to '/login'
		end
	end

	def view_playlist
		playlist_id = params[:id]
		@listen_to = params[:lt]
		order = params[:or]
		if order.to_i == 1
			order = "created_at DESC"
		else 
			order = "id"
		end
		if !@listen_to.present?
			@listen_to = 0
		end
		user = User.where(id: session[:user_id]).first;
		playlist = Playlist.where(id: playlist_id).first
		if playlist.present? && playlist.user_id == session[:user_id]
			@playlist = Playlist.get_playlist(playlist.id, user.id, order)
			@playlist_title = playlist["name"]
			@user_library = User.get_library_id(user).to_i
			if playlist_id.to_i ==  @user_library
				@playlist_title = "My library"
			end
			@tracks = @playlist[:tracks].to_json.html_safe
		else 
			redirect_to '/dashboard'
		end
	end

	def get_music
		music_file_id = params[:id]
		music_file = MusicFile.where(id: music_file_id).first

		if music_file.present?
			location = music_file.file_location
			if File.exists?(location)
				filename = File.basename(location)
				file_size = File.stat(location).size
				file_modified_at = File.mtime(location).to_s
				file_begin = 0;
				file_end = file_size - 1;

				if !request.headers["Range"]
					status_code = "200 OK"
				else
					status_code = "206 Partial Content"
					match = request.headers["Range"].match(/bytes=(\d+)-(\d*)/)
					
					if match
				    	file_begin = match[1]
				    	if match[2] && !match[2].empty?
				     		file_end = match[2]
				     	end
				     	puts file_begin.to_s + "-" + file_end.to_s
				    end
					response.header["Content-Range"] = "bytes " + file_begin.to_s + "-" + file_end.to_s + "/" + file_size.to_s
				end
				response.header["Content-Length"] = (file_end.to_i - file_begin.to_i + 1).to_s
				response.header["Last-Modified"] = file_modified_at
				response.header["Cache-Control"] = "public, must-revalidate, max-age=600"
				response.header["Accept-Ranges"] =  "bytes"
				response.header["Content-Transfer-Encoding"] = "binary"
				puts 'file end: ' + file_end.to_s + " file start: " + file_begin.to_s
				data = IO.binread(location, file_end.to_i - file_begin.to_i + 1, file_begin.to_i)
				send_data(data, 
				            :filename => filename,
				            :type => "application/octet-stream", 
				            :disposition => "inline",
				            :status => status_code,
				            :stream =>  'true',
            				:buffer_size  =>  4096)
			end
		end
	end

	def create_playlist
		ptitle = params[:ptitle]
		playlist = Playlist.where("name like ? and user_id = ?", "%" + ptitle + "%", session[:user_id]).first
		if playlist.present?
			render :json => {:status => 1}
		else
			playlist = Playlist.create(name: ptitle, user_id: session[:user_id])
			render :json => {:status => 0, :pid => playlist.id}
		end
	end

	def get_songs
		user = User.where(id: session[:user_id]).first
		if user.present?
			library_id = User.get_library_id(user)
			library = Playlist.get_playlist(library_id, user.id, nil)
			render :json => {:status => 0, :library => library[:tracks]}
		else
			render :json => {:status => 1}
		end
	end

	def add_to_playlist
		playlist_id = params[:playlist].to_i
		ids = params[:ids].split(",")
		music_files = []
		ids.each do |id|
			file = MusicFile.where(id: id.to_i).first
			if file.present?
				file.add_to_playlist(playlist_id)	
			end
			music_files.push(file.describe(nil))
		end
		render :json => {status: 0, songs: music_files}
	end

	def my_playlists
		user = User.where(id: session[:user_id]).first
		@username = user.username
		@playlists = Playlist.get_all_playlist(user)
	end
end
