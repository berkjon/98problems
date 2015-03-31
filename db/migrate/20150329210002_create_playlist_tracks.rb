class CreatePlaylistTracks < ActiveRecord::Migration
  def change
    create_table :playlist_tracks do |t|
      t.belongs_to :playlist, index: true
      t.belongs_to :track, index: true

      t.timestamps null: false
    end
  end
end
