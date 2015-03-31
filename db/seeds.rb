# 5.times {User.create(display_name: Faker::Name.name)}
# User.all.each {|user| user.playlists.create(name: Faker::Name.)}

5.times do
  user = User.create(display_name: Faker::Name.name)
  4.times do
    playlist = user.playlists.create(name: Faker::Hacker.noun)
    5.times do
      track = playlist.tracks.create(name: Faker::App.name)
      5.times do
        tag = track.tags.create(tag: Faker::Commerce.color)
      end
    end
  end
end