class FixColumnNames < ActiveRecord::Migration
  def change
  	rename_column :music_artists, :music_id, :music_file_id
  	rename_column :music_files, :genre, :genre_id
  	rename_column :music_files, :album, :album_id
  	rename_column :music_playlists, :music_id, :music_file_id
  end
end
