class CreateMusicPlaylists < ActiveRecord::Migration
  def change
    create_table :music_playlists do |t|
      t.integer :music_id
      t.integer :playlist_id

      t.timestamps null: false
    end
  end
end
