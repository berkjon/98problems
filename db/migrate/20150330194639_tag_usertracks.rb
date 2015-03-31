class TagUsertracks < ActiveRecord::Migration
  def change
    create_table :tag_usertracks do |t|
      t.belongs_to :tag, index: true
      t.belongs_to :user_track, index: true

      t.timestamps null: false
    end
  end
end
