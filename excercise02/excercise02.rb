# Bài tập 1: Tạo DSL cho quản lý lịch học (Block + yield)
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


#   Bài tập 2: Hệ thống retry với callback (Proc)
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