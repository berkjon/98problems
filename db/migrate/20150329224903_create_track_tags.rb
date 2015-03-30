class CreateTrackTags < ActiveRecord::Migration
  def change
    create_table :track_tags do |t|
      t.belongs_to :track, index: true
      t.belongs_to :tag, index: true

      t.timestamps null: false
    end
  end
end
