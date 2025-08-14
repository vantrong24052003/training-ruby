# frozen_string_literal: true

# Bài tập 3: Xây dựng bộ lọc dữ liệu linh hoạt (Lambda)
module ActiveRecord
  def by_genre(genre)
    self.class.new(@books.select { |book| book[:genre] === genre })
  end

  def after_year(year)
    self.class.new(@books.select { |book| book[:year] < year })
  end

  def price_between(min_price, max_price)
    self.class.new(@books.select { |book| book[:price].between?(min_price, max_price) })
  end

  def each(&)
    self.class.new(@books.each(&))
  end

  def available
    self.class.new(@books.select { |book| book[:available] })
  end

  def to_s
    @books.map(&:to_s).join("\n")
  end
end

class BookCollection
  attr_accessor :books

  include ActiveRecord

  def initialize(book)
    @books = book
  end
end

# Ví dụ cách sử dụng khi hoàn thành
books = BookCollection.new([
                             { title: 'Ruby Programming', author: 'Matz', genre: 'Programming', year: 2008, price: 30,
                               available: true },
                             { title: 'Design Patterns', author: 'Gang of Four', genre: 'Programming', year: 1994,
                               price: 45, available: false },
                             { title: 'Clean Code', author: 'Robert Martin', genre: 'Programming', year: 2008,
                               price: 40, available: true },
                             { title: 'Harry Potter', author: 'J.K. Rowling', genre: 'Fantasy', year: 1997, price: 25,
                               available: true }
                           ])

# Sử dụng các scope riêng lẻ
puts "\n"
programming_books = books.by_genre('Programming')
available_books = books.available
puts programming_books
puts "\n"
puts available_books

# Kết hợp các scope
cheap_recent_books = books.after_year(2000).price_between(20, 35).available

puts "\nSách lập trình:"
programming_books.each { |book| puts "- #{book[:title]} (#{book[:author]})" }

puts "\nSách có sẵn để mượn:"
available_books.each { |book| puts "- #{book[:title]}" }

puts "\nSách giá từ 20-35, xuất bản sau 2000 và có sẵn:"
cheap_recent_books.each { |book| puts "- #{book[:title]} - $#{book[:price]} (#{book[:year]})" }
