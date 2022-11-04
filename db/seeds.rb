require 'open-uri'
require 'nokogiri'

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

url = "https://www.bookdepository.com/bestsellers"
html_file = URI.open(url).read
html_doc = Nokogiri::HTML(html_file)
html_doc.search(".book-item").first(10).each do |book|
  book_url = "https://www.bookdepository.com/#{book.search(".item-img a").attribute("href")}"
  next unless URI.open(book_url).read

  html_file_book = URI.open(book_url).read
  html_doc_book = Nokogiri::HTML(html_file_book)
  book = Book.new(title: html_doc_book.search("h1").text.strip,
                  author: html_doc_book.search(".author-info a").text.strip,
                  genre: Faker::Book.genre,
                  price: rand(100..300) / 100,
                  user_id: rand(User.first.id..User.last.id),
                  summary: html_doc_book.search(".item-excerpt").text.strip.delete_suffix!("show more").strip)
  photo_file = URI.open(html_doc_book.search(".item-img-content img").attribute("src"))
  book.photo.attach(io: photo_file, filename: "book#{book.id}_image.png", content_type: "image/png")
  book.save
  puts "Created book with id #{book.id}"
end

# 10.times do
#   book = Book.new(title: Faker::Book.title,
#               author: Faker::Book.author,
#               genre: Faker::Book.genre,
#               price: rand(1..3),
#               user_id: rand(User.first.id..User.last.id),
#               summary: Faker::Lorem.paragraph(sentence_count: 20))
#   photo_file = URI.open("https://upload.wikimedia.org/wikipedia/commons/4/42/Otvorena_knjiga.JPG")
#   book.photo.attach(io: photo_file, filename: "book#{book.id}_image.png", content_type: "image/png")
#   book.save
#   puts "Created book with id #{book.id}"
# end

puts "End"
