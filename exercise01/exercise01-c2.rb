$students = [
    {
        ma_sv: "B20DCCN001",
        ten: "Nguyễn Văn A",
        tuoi: 20,
        diem: 8.0
    },
    {
        ma_sv: "B20DCCN002",
        ten: "Nguyễn Văn B",
        tuoi: 21,
        diem: 7.5
    },
    {
        ma_sv: "B20DCCN003",
        ten: "Nguyễn Văn C",
        tuoi: 22,
        diem: 9.0
    },
    {
        ma_sv: "B20DCCN004",
        ten: "Nguyễn Văn D",
        tuoi: 22,
        diem: 9.0
    }
]

def print_students
    puts "----------------Danh sách sinh viên-----------------"
    $students.each do |student|
        puts student_info(student)
    end
end

def student_info(student)
    "Mã SV: #{student[:ma_sv]}, Tên: #{student[:ten]}, Tuổi: #{student[:tuoi]}, Điểm: #{student[:diem]}"
end

def add_student
    puts "----------------Thêm sinh viên-----------------"
    print "Nhập mã sinh viên: "
    ma_sv = gets.chomp

    $students.each do |student|
        if student[:ma_sv] == ma_sv
            puts "Mã sinh viên đã tồn tại"
            return
        end
       end

    print "Nhập tên sinh viên: "
    ten = gets.chomp
    print "Nhập tuổi sinh viên: "
    tuoi = gets.chomp.to_i
    print "Nhập điểm sinh viên: "
    diem = gets.chomp.to_f

    $students.push({ ma_sv: ma_sv, ten: ten, tuoi: tuoi, diem: diem })
    puts "Thêm sinh viên thành công"
end

def find_student
    print "Nhập mã sinh viên: "
    ma_sv = gets.chomp
    student = $students.find { |s| s[:ma_sv] == ma_sv }

    puts "-----------Thông tin sinh viên cần tìm:------------------"
    puts student ? student_info(student) : "Không tìm thấy sinh viên"
end

def score_avg_student
    avg = $students.sum { |s| s[:diem] } / $students.size.to_f
    puts "Điểm trung bình của sinh viên là: #{avg.round(2)}"
end

def max_score_student
    student = $students.max_by { |s| s[:diem] }
    puts "Sinh viên có điểm cao nhất:"
    puts student_info(student)
end

def filter_list_age_student
    print "Nhập tuổi sinh viên: "
    tuoi = gets.chomp.to_i
    students_by_age = $students.select { |s| s[:tuoi] == tuoi }

    puts students_by_age.empty? ? "Không có sinh viên nào ở tuổi #{tuoi}" :
    "----------------Danh sách sinh viên theo tuổi-----------------"
    students_by_age.each { |student| puts student_info(student) }
end

def remove_student
    print "Nhập mã sinh viên cần xóa: "
    ma_sv = gets.chomp
    if $students.reject! { |s| s[:ma_sv] == ma_sv }
        puts "Xóa sinh viên thành công"
    else
        puts "Không tìm thấy sinh viên"
    end
end

def menu
    loop do
        puts "----------------Menu-----------------"
        puts "1. Thêm sinh viên"
        puts "2. Hiển thị danh sách sinh viên"
        puts "3. Tìm sinh viên"
        puts "4. Điểm trung bình của sinh viên"
        puts "5. Sinh viên có điểm cao nhất"
        puts "6. Danh sách sinh viên theo tuổi"
        puts "7. Xóa sinh viên"
        puts "8. Thoát"
        print "Chọn chức năng: "

        choice = gets.chomp
        case choice
        when "1" 
            add_student
        when "2" 
            print_students
        when "3" 
            find_student
        when "4" 
            score_avg_student
        when "5" 
            max_score_student
        when "6" 
            filter_list_age_student
        when "7" 
            remove_student
        when "8" 
            break
        else puts "Chức năng không tồn tại"
        end
    end
end

menu