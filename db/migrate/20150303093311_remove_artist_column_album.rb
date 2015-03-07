class RemoveArtistColumnAlbum < ActiveRecord::Migration
  def change
  	remove_column :albums, :artists
  end
end
