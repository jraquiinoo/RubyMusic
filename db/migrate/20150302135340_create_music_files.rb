class CreateMusicFiles < ActiveRecord::Migration
  def change
    create_table :music_files do |t|
      t.string :title
      t.integer :artists, array: true
      t.integer :genre
      t.integer :album

      t.timestamps null: false
    end
  end
end
