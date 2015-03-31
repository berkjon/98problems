class TagUsertrack < ActiveRecord::Base
  belongs_to :tag
  belongs_to :user_track
end
