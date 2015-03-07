class AddFileLocationMusicFiles < ActiveRecord::Migration
  def change
  	add_column :music_files, :file_location, :string
  end
end
