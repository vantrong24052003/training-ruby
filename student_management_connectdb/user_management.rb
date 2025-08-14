# frozen_string_literal: true

require_relative 'active_record'
require_relative 'student'
require 'pry'

class UserManagement
  def add_student(ma_sv, ten, tuoi, diem)
    if ma_sv.nil? || ma_sv.empty?
      puts 'Lỗi: Mã sinh viên không được để trống!'
      return
    end

    if ten.nil? || ten.empty?
      puts 'Lỗi: Tên sinh viên không được để trống!'
      return
    end

    unless validate_age?(tuoi)
      puts 'Lỗi: Tuổi phải là số nguyên dương!'
      return
    end

    unless validate_score?(diem, 0, 10)
      puts 'Lỗi: Điểm phải là số từ 0 đến 10!'
      return
    end

    begin
      Student.create(ma_sv: ma_sv, ten: ten, tuoi: tuoi, diem: diem)
      puts '-------------------Đã thêm sinh viên thành công-------------------'
    rescue SQLite3::ConstraintException
      puts 'Lỗi: Mã sinh viên đã tồn tại!'
    rescue SQLite3::SQLException => e
      puts "Lỗi SQL: #{e.message}"
    end
  end

  def list_students
    students = Student.all
    if students.empty?
      puts 'Danh sách sinh viên trống!'
    else
      print_student(students)
    end
  end

  def find_student(ma_sv)
    if ma_sv.nil? || ma_sv.empty?
      puts 'Lỗi: Mã sinh viên không được để trống!'
      return
    end

    student = Student.find(ma_sv)

    if student
      puts "------------Sinh viên #{ma_sv} được tìm thấy------------"
      puts "#{student.ten}, Điểm: #{student.diem}"
    else
      puts 'Không tìm thấy sinh viên!'
    end
  end

  def average_score
    avg = Database::DB.get_first_value('SELECT AVG(diem) FROM student')
    puts "Điểm trung bình của lớp: #{avg.nil? ? 'Chưa có sinh viên' : avg.round(2)}"
  end

  def highest_score_student
    student = Database::DB.get_first_row('SELECT * FROM student ORDER BY diem DESC LIMIT 1')

    if student
      puts "Sinh viên điểm cao nhất: #{student['ten']}, Điểm: #{student['diem']}"
    else
      puts 'Danh sách rỗng!'
    end
  end

  def filter_students_by_age(age)
    unless validate_age?(age)
      puts 'Lỗi: Tuổi phải là số nguyên dương!'
      return
    end

    students = Student.where(tuoi: age)

    if students.empty?
      puts "Không tìm thấy sinh viên nào có tuổi #{age}!"
    else
      students.each do |student|
        puts "Mã: #{student.ma_sv}, Tên: #{student.ten}, Điểm: #{student.diem}"
      end
    end
  end

  def delete_student(ma_sv)
    if ma_sv.nil? || ma_sv.empty?
      puts 'Lỗi: Mã sinh viên không được để trống!'
      return
    end

    student = Student.find(ma_sv)

    if student
      student.destroy
      puts "Đã xóa sinh viên có mã: #{ma_sv}"
    else
      puts 'Không tìm thấy sinh viên để xóa!'
    end
  end

  def print_student(students)
    students.each do |student|
      puts "Mã: #{student.ma_sv}, Tên: #{student.ten}, Tuổi: #{student.tuoi}, Điểm: #{student.diem}"
    end
  end

  def first_student
    student = Student.first

    if student
      puts "Mã: #{student.ma_sv}, Tên: #{student.ten}, Tuổi: #{student.tuoi}, Điểm: #{student.diem}"
    else
      puts 'Danh sách rỗng!'
    end
  end

  def last_student
    student = Student.last

    if student
      puts "Mã: #{student.ma_sv}, Tên: #{student.ten}, Tuổi: #{student.tuoi}, Điểm: #{student.diem}"
    else
      puts 'Danh sách rỗng!'
    end
  end

  def filter_students_by_condition(condition)
    students = Student.where(condition)

    if students.empty?
      puts 'Không tìm thấy sinh viên nào!'
    else
      print_student(students)
    end
  end

  private # methods ngoài gọi tới thông qua methods khác có sử dụng các methods private này thì cho phép, còn gọi trực tiếp thì lỗi

  def validate_age?(value)
    return true if value.is_a?(Integer) && value.positive?

    false
  end

  def validate_score?(value, min, max)
    return true if value.is_a?(Numeric) && value >= min && value <= max

    false
  end
end
