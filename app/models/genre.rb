class Genre < ActiveRecord::Base
	has_many :music_files

	def self.save(name)
		genre = Genre.where(name: name).first
		if !genre.present?
			genre = Genre.new(name: name)
			genre.save
		end
		genre
	end
end
