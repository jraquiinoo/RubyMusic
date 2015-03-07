class Album < ActiveRecord::Base
	has_many :music_files, dependent: :destroy
	belongs_to :artist

	def self.save(name, year, artist_name)
		artist = Artist.where('name like ?', '%' + artist_name.to_s + '%').first
		if !artist.present?
			artist = Artist.create(name: artist_name)
			album = Album.create(name: name, year: year, artist_id: artist.id)
		else
			album = Album.where(name: name).first
			if !album.present?
				album = Album.create(name: name, year: year, artist_id: artist.id)
			end
		end
		album
	end
end
