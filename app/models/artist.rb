class Artist < ActiveRecord::Base
	has_many :albums, dependent: :destroy
	has_many :music_artists
	has_many :music_files, through: :music_aritsts
end
