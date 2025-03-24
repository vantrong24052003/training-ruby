# frozen_string_literal: true

$students = [
  {
    ma_sv: 'B20DCCN001',
    ten: 'Nguyễn Văn A',
    tuoi: 20,
    diem: 8.0
  },
  {
    ma_sv: 'B20DCCN002',
    ten: 'Nguyễn Văn B',
    tuoi: 21,
    diem: 7.5
  },
  {
    ma_sv: 'B20DCCN003',
    ten: 'Nguyễn Văn C',
    tuoi: 22,
    diem: 9.0
  },
  {
    ma_sv: 'B20DCCN004',
    ten: 'Nguyễn Văn D',
    tuoi: 22,
    diem: 9.0
  }
]

def print_student
  puts '----------------Danh sách sinh viên-----------------'
  $students.each do |student|
    puts "Mã sinh viên: #{student[:ma_sv]}"
    puts "Tên sinh viên: #{student[:ten]}"
    puts "Tuổi sinh viên: #{student[:tuoi]}"
    puts "Điểm sinh viên: #{student[:diem]}"
    puts ' '
  end
end

def add_student
  puts '----------------Thêm sinh viên-----------------'
  print 'Nhập mã sinh viên: '
  ma_sv = gets.chomp

  $students.each do |student|
    if student[:ma_sv] == ma_sv
      puts 'Mã sinh viên đã tồn tại'
      return
    end
  end

  print 'Nhập tên sinh viên: '
  ten = gets.chomp
  print 'Nhập tuổi sinh viên: '
  tuoi = gets.chomp.to_i
  print 'Nhập điểm sinh viên: '
  diem = gets.chomp.to_f

  $students.push({
                   ma_sv: ma_sv,
                   ten: ten,
                   tuoi: tuoi,
                   diem: diem
                 })
  puts 'Thêm sinh viên thành công'
end

def find_student
  print 'Nhập mã sinh viên: '
  ma_sv = gets.chomp
  infor_student = nil
  $students.each do |student|
    if student[:ma_sv].eql?(ma_sv)
      infor_student = student
      break
    end
  end
  puts '-----------Thông tin sinh viên cần tìm:------------------'
  if infor_student.nil?
    puts 'Không tìm thấy sinh viên'
  else
    puts "Mã sinh viên: #{infor_student[:ma_sv]}"
    puts "Tên sinh viên: #{infor_student[:ten]}"
    puts "Tuổi sinh viên: #{infor_student[:tuoi]}"
    puts "Điểm sinh viên: #{infor_student[:diem]}"
  end
end

def score_avg_student
  sum = 0
  $students.each do |student|
    sum += student[:diem]
  end
  avg = sum / $students.length
  puts "Điểm trung bình của sinh viên là: #{avg}"
end

def max_score_student
  user = nil
  $students.each do |student|
    user = student if user.nil? || student[:diem] > user[:diem]
  end
  puts 'Sinh viên có điểm cao nhất:'
  puts "Mã sinh viên: #{user[:ma_sv]}"
  puts "Tên sinh viên: #{user[:ten]}"
  puts "Tuổi sinh viên: #{user[:tuoi]}"
  puts "Điểm sinh viên: #{user[:diem]}"
end

def filter_list_age_student
  puts '----------------Danh sách sinh viên theo tuổi-----------------'
  print 'Nhập tuổi sinh viên: '
  tuoi = gets.chomp.to_i
  $students.each do |student|
    next unless student[:tuoi].eql?(tuoi)

    puts "Mã sinh viên: #{student[:ma_sv]}"
    puts "Tên sinh viên: #{student[:ten]}"
    puts "Tuổi sinh viên: #{student[:tuoi]}"
    puts "Điểm sinh viên: #{student[:diem]}"
    puts ' '
  end
end

def remove_student
  print 'Nhập mã sinh viên cần xóa: '
  ma_sv = gets.chomp
  $students.each_with_index do |student, index|
    next unless student[:ma_sv].eql?(ma_sv)

    $students.delete_at(index)
    puts 'Xóa sinh viên thành công'
    return
  end
  puts 'Không tìm thấy sinh viên'
end

def menu
  loop do
    puts '----------------Menu-----------------'
    puts '1. Thêm sinh viên'
    puts '2. Hiển thị danh sách sinh viên'
    puts '3. Tìm sinh viên'
    puts '4. Điểm trung bình của sinh viên'
    puts '5. Sinh viên có điểm cao nhất'
    puts '6. Danh sách sinh viên theo tuổi'
    puts '7. Xóa sinh viên'
    puts '8. Thoát'
    print 'Chọn chức năng: '
    choice = gets.chomp
    case choice
    when '1'
      add_student
    when '2'
      print_student
    when '3'
      find_student
    when '4'
      score_avg_student
    when '5'
      max_score_student
    when '6'
      filter_list_age_student
    when '7'
      remove_student
    when '8'
      return
    else
      puts 'Chức năng không tồn tại'
    end
  end
end

menu
