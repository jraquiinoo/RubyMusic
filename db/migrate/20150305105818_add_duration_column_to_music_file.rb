class AddDurationColumnToMusicFile < ActiveRecord::Migration
  def change
  	add_column :music_files, :duration, :integer
  end
end
