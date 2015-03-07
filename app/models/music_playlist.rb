class MusicPlaylist < ActiveRecord::Base
	has_one :music_file
	has_one :playlist

	def self.get_playlist(playlist_id, order)
		music_files = [];
		if !order.present?
			order = "id"
		end
		music_playlists = MusicPlaylist.where(playlist_id: playlist_id).order(order).all.to_a
		music_playlists.each do |music_playlist|
			music_file = MusicFile.where(id: music_id).first
			genre = Genre.where(id: music_file.genre_id).first
			album = Album.where(id: music_file.album_id).first
			artist = Artist.where(id: album.artist_id).first

			current_music = {
				"id" => music_file.id, 
				"title" => music_file.title, 
				"genre" => {
						"name" => genre.name,
						"id" => genre.id
					},
				"album" => {
						"id" => album.id,
						"title" => album.name,
						"year" => album.year
					},
				"artist" => {
						"id" => artist.id,
						"name" => artist.name
					},
				"duration" => music_file.duration,
				"link" => "/music?" + music_file.id
			}
			music_files.push(current_music)
		end
		playlist = {
			"id" => playlist_id,
			"name" => "Asd"
		}
		music_files
	end

end
