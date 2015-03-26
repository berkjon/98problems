class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :access_token
      t.integer :access_token_duration
      t.time :access_token_created_at
      t.string :refresh_token

      t.string :spotify_id
      t.string :display_name
      t.string :email
      t.string :photo_url
      t.string :profile_url

      t.timestamps null: false
    end
  end
end
