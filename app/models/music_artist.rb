class MusicArtist < ActiveRecord::Base
	has_one :music_file
	has_one :artist
end
