class AddArtLocation < ActiveRecord::Migration
  def change
  	add_column :music_files, :art_location, :string
  end
end
