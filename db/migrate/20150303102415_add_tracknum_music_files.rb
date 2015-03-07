class AddTracknumMusicFiles < ActiveRecord::Migration
  def change
  	add_column :music_files, :tracknum, :integer
  end
end
