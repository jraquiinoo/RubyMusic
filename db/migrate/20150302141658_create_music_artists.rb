class CreateMusicArtists < ActiveRecord::Migration
  def change
    create_table :music_artists do |t|
      t.integer :music_id
      t.integer :artist_id

      t.timestamps null: false
    end
  end
end
