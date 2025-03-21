# # Bài tập 1: Tạo DSL cho quản lý lịch học (Block + yield)
puts "Bài tập 1: Tạo DSL cho quản lý lịch học (Block + yield)"
require 'time' 
class Lesson
    attr_accessor :subject, :time, :room, :teacher 

    def initialize(subject, time, room, teacher)
        @subject = subject
        @time_str = time 
        @time = parse_time(time) 
        @room = room
        @teacher = teacher
      end

    # to_string methods
    def to_s
        "Subject: #{@subject}, Time: #{@time_str}, Room: #{@room}, Teacher: #{@teacher}"
    end
    
    private

    def parse_time(time_str)
      Time.parse(time_str.split('-').first)
    end
end


class Schedule
    
    def initialize(name)
        @name = name
        @lessons = []
        yield self if block_given? 
      end
   
      def add_session(subject, time:, room:, teacher:)
        @lessons.push(Lesson.new(subject, time, room, teacher))
    end

    def print_schedule
        puts "#{@name}"
        sorted_lessons = @lessons.sort_by(&:time) 
        sorted_lessons.each { |lesson| puts lesson }
      end
end

# Create a new schedule
schedule = Schedule.new("Lịch học Ruby") do |s|
    s.add_session "Ruby nâng cao", time: "13:00-15:00", room: "A1.02", teacher: "Trần Thị B"
    s.add_session "Ruby cơ bản", time: "9:00-11:00", room: "A1.01", teacher: "Nguyễn Văn A"
    s.add_session "Rails cơ bản", time: "15:30-17:30", room: "A1.03", teacher: "Lê Văn C"
  end
  
  schedule.print_schedule


# #   Bài tập 2: Hệ thống retry với callback (Proc)
puts "\nBài tập 2: Hệ thống retry với callback (Proc)"
module Retryable
    def with_retry(max_attempts:, wait_time:, on_retry: nil, on_error: nil, on_success: nil)
      attempts = 0
  
      begin
        attempts += 1
        result = yield # Thực thi block được truyền vào
        on_success.call(result) if on_success
        return result
      rescue => e
        if attempts < max_attempts
          on_retry.call(attempts, e) if on_retry
          sleep wait_time
          retry
        else
          on_error.call(e) if on_error
          raise e
        end
      end
    end
  end
  
  include Retryable
  
  on_retry_proc = Proc.new { |attempt, exception| puts "Retry lần #{attempt} sau lỗi: #{exception.message}" }
  on_error_proc = Proc.new { |exception| puts "Thất bại sau tất cả các lần thử! Lỗi: #{exception.message}" }
  on_success_proc = Proc.new { |result| puts "Thành công! Kết quả: #{result}" }
  
  result = with_retry(
    max_attempts: 3,
    wait_time: 1,
    on_retry: on_retry_proc,
    on_error: on_error_proc,
    on_success: on_success_proc
  ) do
    # Giả lập một API call không ổn định
    random = rand(10)
    if random < 7
      raise "Connection timeout"
    end
    "Dữ liệu từ API"
  end
  
  puts "Kết quả cuối cùng: #{result}"

  #Bài tập 3: Xây dựng bộ lọc dữ liệu linh hoạt (Lambda)
module ActiveRecord
  def by_genre(genre)
    self.class.new(@books.select {|book| book[:genre] === genre})
   end
   
   def after_year(year)
    self.class.new(@books.select {|book| book[:year] < year})
   end

   def price_between(min_price, max_price)
    self.class.new(@books.select {|book| book[:price].between?(min_price , max_price )})
   end

   def each(&block)
    self.class.new(@books.each(&block))
   end

   def available
    self.class.new(@books.select {|book| book[:available]})
   end    

   def to_s
    @books.map{|book| book.to_s}.join("\n")
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
  {title: "Ruby Programming", author: "Matz", genre: "Programming", year: 2008, price: 30, available: true},
  {title: "Design Patterns", author: "Gang of Four", genre: "Programming", year: 1994, price: 45, available: false},
  {title: "Clean Code", author: "Robert Martin", genre: "Programming", year: 2008, price: 40, available: true},
  {title: "Harry Potter", author: "J.K. Rowling", genre: "Fantasy", year: 1997, price: 25, available: true}
])

# Sử dụng các scope riêng lẻ
puts "\n"
programming_books = books.by_genre("Programming")
available_books = books.available
puts programming_books
puts "\n"
puts  available_books

# Kết hợp các scope
cheap_recent_books = books.after_year(2000).price_between(20, 35).available

puts "\nSách lập trình:"
programming_books.each { |book| puts "- #{book[:title]} (#{book[:author]})" }

puts "\nSách có sẵn để mượn:"
available_books.each { |book| puts "- #{book[:title]}" }

puts "\nSách giá từ 20-35, xuất bản sau 2000 và có sẵn:"
cheap_recent_books.each { |book| puts "- #{book[:title]} - $#{book[:price]} (#{book[:year]})" }
   

# Bài tập 4: Xây dựng logger có cấu hình linh hoạt (Block, Proc và Lambda)
class FlexLogger
  def initialize
    @handlers = {}
  end

  def add_handler(name, filter: nil, formatter: nil, &block)
    @handlers[name] = { filter: filter, formatter: formatter, block: block }
  end

  def log(level, message)
    @handlers.each_value do |handler|
      next if handler[:filter] && !handler[:filter].call(message, level)
      formatted_message = handler[:formatter] ? handler[:formatter].call(message, level) : message
      handler[:block].call(formatted_message, level)
    end
  end

  def debug(message)
    log(:debug, message)
  end

  def info(message)
    log(:info, message)
  end

  def warn(message)
    log(:warn, message)
  end

  def error(message)
    log(:error, message)
  end
end

# Ví dụ cách sử dụng khi hoàn thành
logger = FlexLogger.new

# Thêm console handler bằng block
logger.add_handler("console") do |message, level|
  puts "[#{level.upcase}] #{message}"
end

# Thêm file handler với bộ lọc (chỉ log error) và định dạng riêng
only_errors = ->(message, level) { level == :error }
timestamp_format = Proc.new { |msg, lvl| "#{Time.now} [#{lvl.upcase}] #{msg}" }

logger.add_handler("file", filter: only_errors, formatter: timestamp_format) do |message, level|
  File.open("error.log", "a") do |file|
    file.puts message
  end
end

# Sử dụng logger
logger.debug "Đây là debug message"
logger.info "Ứng dụng đã khởi động"
logger.warn "Cảnh báo: Disk space thấp"
logger.error "Lỗi kết nối database!"
