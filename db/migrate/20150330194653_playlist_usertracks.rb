class PlaylistUsertracks < ActiveRecord::Migration
  def change
    create_table :playlist_usertracks do |t|
      t.belongs_to :playlist, index: true
      t.belongs_to :user_track, index: true

      t.timestamps null: false
    end
  end
end
