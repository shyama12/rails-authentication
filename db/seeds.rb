require 'open-uri'

puts "Start"
Book.destroy_all
Booking.destroy_all
User.destroy_all
puts "Cleaned the DB"

5.times do
  User.create(first_name: Faker::Name.male_first_name,
              last_name: Faker::Name.last_name,
              address: Faker::Address.street_address,
              email: Faker::Internet.email,
              password: '123456')
end

5.times do
  User.create(first_name: Faker::Name.female_first_name,
              last_name: Faker::Name.last_name,
              address: Faker::Address.street_address,
              email: Faker::Internet.email,
              password: '123456')
end

puts "Created #{User.count} users"

10.times do
  book = Book.new(title: Faker::Book.title,
              author: Faker::Book.author,
              genre: Faker::Book.genre,
              price: rand(1..3),
              user_id: rand(User.first.id..User.last.id),
              summary: Faker::Lorem.paragraph(sentence_count: 20))
  photo_file = URI.open("https://upload.wikimedia.org/wikipedia/commons/4/42/Otvorena_knjiga.JPG")
  book.photo.attach(io: photo_file, filename: "book#{book.id}_image.png", content_type: "image/png")
  book.save
  puts "Created book with id #{book.id}"
end

puts "End"
