class MusicFile < ActiveRecord::Base
	has_one :album
	has_many :music_artists
	has_many :aritsts, through: :music_artists
	has_many :music_playlists
	has_many :playlists, through: :music_playlists

	def self.save(file, user_id, playlist_id)
		user = User.where(id: user_id).first
		name =  file.original_filename
	    directory = "public/data/music/" + user_id.to_s()
		require 'rubygems'
		require 'mp3info'
		require 'fileutils'
		unless File.directory?(directory)
		  FileUtils.mkdir_p(directory)
		end

	    path = File.join(directory, name)
	    if File.exists?(path)
	    	nil
	    else 
	    	File.open(path, "w+b") { |f| f.write(file.read) }
	    	#extract music information
			Mp3Info.open(path) do |mp3info|
			  title = mp3info.tag.title
			  if !title.present?
			  	title = "Unknown"
			  end
			  artist = mp3info.tag.artist
			  if !artist.present?
			  	artist = "Unknown"
			  end
			  album = mp3info.tag.album
			  if !album.present?
			  	album = "Unknown"
			  end
			  year = mp3info.tag.year
			  if !year.present?
			  	year = -1
			  end
			  tracknumber = mp3info.tag.tracknum
			  if !tracknumber.present?
			  	tracknumber = -1
			  end
			  genre = mp3info.tag.genre_s
			  if !genre.present?
			  	genre = "Unknown"
			  end
			  duration = mp3info.length

			  pictures = mp3info.tag2.pictures
			  album_art = nil
			  if pictures.present? && pictures.size > 0
		  		pictures.each do |description, data|
		  			File.binwrite(path.gsub(".mp3",".jpg"), data)
		  		end
		  		album_art = path.gsub(".mp3", ".jpg").gsub("public/","")
			  end
			  savedAlbum = Album.save(album, year, artist)
			  savedGenre = Genre.save(genre)
			  music_file = MusicFile.create(title: title, genre_id: savedGenre.id, 
			  	album_id: savedAlbum.id, tracknum: tracknumber, file_location: path, 
			  	duration: duration, art_location: album_art)
			  MusicArtist.create(artist_id: savedAlbum.artist_id, music_file_id: music_file.id)
			  user_library_id = User.get_library_id(user)
			  music_file.add_to_playlist(user_library_id)
			  if playlist_id.present? 
			  	music_file.add_to_playlist(playlist_id)
			  end
	    	  artist = Artist.where(id: Album.where(id: savedAlbum.id).first[:artist_id]).first
				saved_song = {
					:id => music_file.id,
					:title => music_file.title,
					:album => {
						:id => savedAlbum.id,
						:name => savedAlbum.name
					}
				}

				current_music = {
					id: music_file.id, 
					title: music_file.title, 
					genre: {
							name: savedGenre.name,
							id: savedGenre.id
						},
					album: {
							id: savedAlbum.id,
							title: savedAlbum.name,
							year: savedAlbum.year
						},
					artist: {
							id: artist.id,
							name: artist.name
						},
					duration: music_file.duration,
					link: "/music?id=" + music_file.id.to_s
					}
			end
		end
	end

	def add_to_playlist(playlist_id)
		music_playlist = MusicPlaylist.where(playlist_id: playlist_id, music_file_id: id).first
		if !music_playlist.present?
			music_playlist = MusicPlaylist.create(playlist_id: playlist_id, music_file_id: id)
		end
		music_playlist
	end

	def describe(play_index)
		genre = Genre.where(id: genre_id).first
		album = Album.where(id: album_id).first
		artist = Artist.where(id: album.artist_id).first
		current_music = {
			id: id, 
			title: title, 
			genre: {
					name: genre.name,
					id: genre.id
				},
			album: {
					id: album.id,
					title: album.name,
					year: album.year
				},
			artist: {
					id: artist.id,
					name: artist.name
				},
			duration: duration,
			link: "/music?id=" + id.to_s,
			index: play_index,
			album_art: art_location
		}
	end
end
