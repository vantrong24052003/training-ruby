# frozen_string_literal: true

# Bài tập 1: Tạo DSL cho quản lý lịch học (Block + yield)
puts 'Bài tập 1: Tạo DSL cho quản lý lịch học (Block + yield)'
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
    puts @name
    sorted_lessons = @lessons.sort_by(&:time)
    sorted_lessons.each { |lesson| puts lesson }
  end
end

# Create a new schedule
schedule = Schedule.new('Lịch học Ruby') do |s|
  s.add_session 'Ruby nâng cao', time: '13:00-15:00', room: 'A1.02', teacher: 'Trần Thị B'
  s.add_session 'Ruby cơ bản', time: '9:00-11:00', room: 'A1.01', teacher: 'Nguyễn Văn A'
  s.add_session 'Rails cơ bản', time: '15:30-17:30', room: 'A1.03', teacher: 'Lê Văn C'
end

schedule.print_schedule
