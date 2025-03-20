require_relative 'user_management'

manager = UserManagement.new

loop do

  puts "\n--------------MENU QUẢN LÝ SINH VIÊN--------------"
  puts "1. Thêm sinh viên"
  puts "2. Hiển thị danh sách"
  puts "3. Tìm sinh viên"
  puts "4. Điểm trung bình"
  puts "5. Sinh viên điểm cao nhất"
  puts "6. Lọc sinh viên theo tuổi"
  puts "7. Xóa sinh viên"
  puts "8. Thoát"
  print "Chọn: "

  choice = gets.to_i

  case choice
  when 1
    print "Mã SV: " 
    ma_sv = gets.chomp
    print "Tên: " 
    ten = gets.chomp
    print "Tuổi: " 
    tuoi = gets.to_i
    print "Điểm: "
     diem = gets.to_f
    student = Student.new(ma_sv, ten, tuoi, diem)
    manager.add_student(student)
  when 2 then manager.list_students
  when 3
    print "Nhập mã SV:" 
    manager.find_student(gets.chomp)
  when 4 then manager.average_score
  when 5 then manager.highest_score_student
  when 6
    print "Nhập tuổi cần lọc: " 
    manager.filter_students_by_age(gets.to_i)
  when 7
    print "Nhập mã SV cần xóa: " 
    manager.delete_student(gets.chomp)
  when 8
    break
  else
    puts "Lựa chọn không hợp lệ!"
  end

end
