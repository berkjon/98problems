# 5.times {User.create(display_name: Faker::Name.name)}
# User.all.each {|user| user.playlists.create(name: Faker::Name.)}