class Playlist < ActiveRecord::Base
	has_many :music_playlists
	has_many :music_files, through: :music_playlists
	has_one :user


	def self.create_playlist(name, user_id)
		playlist = Playlist.where(user_id: user_id, name: name).first
		if !playlist.present?
			playlist = Playlist.new(name: name, user_id: user_id)
			playlist.save
			playlist
		else 
			return nil
		end
	end


	def self.get_playlist(playlist_id, user_id, order)
		playlist = Playlist.where(id: playlist_id).first
		if !order.present?
			order = "id"
		end
		if playlist.present? && playlist.user_id == user_id
			music_files = []
			music_playlist = MusicPlaylist.where(playlist_id: playlist.id).order(order).all.to_a
			music_playlist.each_with_index do |mp, index|
				music_file = MusicFile.where(id: mp.music_file_id).first
				music_files.push(music_file.describe(index))
			end
			final_playlist = {
				id: playlist.id,
				name: playlist.name,
				tracks: music_files
			}
			final_playlist
		else
			nil
		end
	end

	def self.get_all_playlist(user)
		playlists = Playlist.where("user_id = ? and id != ?", user.id, User.get_library_id(user)).all.to_a
		if playlists.present? && playlists.size > 0

			user_playlists = []
			playlists.each do |playlist|

				music_playlists = MusicPlaylist.where(playlist_id: playlist.id).all.to_a
				current_playlist = {
					:song_count => music_playlists.size,
					:name => playlist.name,
					:id => playlist.id
				}
				user_playlists.push(current_playlist)
			end
			user_playlists
		else
			nil
		end
	end
end
