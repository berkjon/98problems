class UserTracks < ActiveRecord::Migration
  def change
    create_table :user_tracks do |t|
      t.belongs_to :user, index: true
      t.belongs_to :track, index: true

      t.timestamps null: false
    end
  end
end
