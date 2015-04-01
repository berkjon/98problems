class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :spotify_id
      t.string :title
      t.string :cover_art
      t.string :artist
      t.string :artist_spotify_id
      t.string :album
      t.string :album_spotify_id

      t.timestamps null: false
    end
  end
end
