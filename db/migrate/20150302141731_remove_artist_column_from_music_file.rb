class RemoveArtistColumnFromMusicFile < ActiveRecord::Migration
  def change
  	remove_column :music_files, :artists
  end
end
