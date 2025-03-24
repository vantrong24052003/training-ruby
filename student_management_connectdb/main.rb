# frozen_string_literal: true

require_relative 'user_management'
require_relative 'student'
require 'pry'

user_management = UserManagement.new

loop do
  puts "\n--------------MENU QUẢN LÝ SINH VIÊN--------------"
  puts '1. Thêm sinh viên'
  puts '2. Hiển thị danh sách'
  puts '3. Tìm sinh viên'
  puts '4. Điểm trung bình'
  puts '5. Sinh viên điểm cao nhất'
  puts '6. Lọc sinh viên theo tuổi'
  puts '7. Xóa sinh viên'
  puts '8. Lọc theo điều kiện'
  puts '9. Lấy sinh viên đầu tiên'
  puts '10. Lấy sinh viên cuối cùng'
  puts '11. Thoát'
  print 'Chọn: '

  choice = gets.to_i

  case choice
  when 1
    print 'Nhập mã sinh viên: '
    ma_sv = gets.chomp
    print 'Nhập tên sinh viên: '
    ten = gets.chomp
    print 'Nhập tuổi: '
    tuoi = gets.to_i
    print 'Nhập diểm:'
    diem = gets.to_f
    user_management.add_student(ma_sv, ten, tuoi, diem)
  when 2
    user_management.list_students
  when 3
    print 'Nhập mã sinh viên: '
    user_management.find_student(gets.chomp)
  when 4
    user_management.average_score
  when 5
    user_management.highest_score_student
  when 6
    print 'Nhập tuổi cần lọc: '
    user_management.filter_students_by_age(gets.to_i)
  when 7
    print 'Nhập mã SV cần xóa: '
    user_management.delete_student(gets.chomp)
  when 8
    print 'Lọc theo điều kiện (ví dụ: "tuoi: 20"): '
    input = gets.chomp
    condition_hash = input.split(',').to_h do |pair|
      key, value = pair.strip.split(':').map(&:strip)
      [key.to_sym, value.to_i]
    end

    user_management.filter_students_by_condition(condition_hash)

  when 9
    user_management.first_student
  when 10
    user_management.last_student
  when 11
    break
  else
    puts 'Lựa chọn không hợp lệ!'
  end
end
