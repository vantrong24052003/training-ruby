    require_relative 'database'
    require_relative 'student'

    class UserManagement
    def initialize
        Database.setup
    end

    def add_student(student)
        if student.student_id.nil? || student.student_id.strip.empty?
        puts "Lỗi: Mã sinh viên không được để trống!"
        return
        end

        if student.name.nil? || student.name.strip.empty?
        puts "Lỗi: Tên sinh viên không được để trống!"
        return
        end

        if !validate_age?(student.age)
        puts "Lỗi: Tuổi phải là số nguyên dương!"
        return
        end

        if !validate_score?(student.score, 0, 10)
        puts "Lỗi: Điểm phải là số từ 0 đến 10!"
        return
        end

        begin
        Database::DB.execute(
            "INSERT INTO student (ma_sv, ten, tuoi, diem) VALUES (?, ?, ?, ?)",
            [student.student_id, student.name, student.age, student.score]
        )
        puts "Đã thêm sinh viên: #{student.name}"
        rescue SQLite3::ConstraintException
        puts "Lỗi: Mã sinh viên đã tồn tại!"
        rescue SQLite3::SQLException => e
        puts "Lỗi SQL: #{e.message}"
        end
    end

    def list_students
        begin
        students = Database::DB.execute("SELECT * FROM student")

        if students.empty?
            puts "Danh sách sinh viên trống!"
        else
            students.each do |sv|
            puts "Mã: #{sv['ma_sv']}, Tên: #{sv['ten']}, Tuổi: #{sv['tuoi']}, Điểm: #{sv['diem']}"
            end
        end
        rescue SQLite3::SQLException => e
        puts "Lỗi SQL: #{e.message}"
        end
    end

    def find_student(student_id)
        if student_id.nil? || student_id.strip.empty?
        puts "Lỗi: Mã sinh viên không được để trống!"
        return
        end

        begin
        student = Database::DB.get_first_row("SELECT * FROM student WHERE ma_sv = ?", [student_id])

        if student
            puts "------------Sinh viên #{student_id} được tìm thấy------------"
            puts "#{student['ten']}, Điểm: #{student['diem']}"
        else
            puts "Không tìm thấy sinh viên!"
        end
        rescue SQLite3::SQLException => e
        puts "Lỗi SQL: #{e.message}"
        end
    end

    def average_score
        begin
        avg = Database::DB.get_first_value("SELECT AVG(diem) FROM student")
        puts "Điểm trung bình của lớp: #{avg.nil? ? 'Chưa có sinh viên' : avg.round(2)}"
        rescue SQLite3::SQLException => e
        puts "Lỗi SQL: #{e.message}"
        end
    end

    def highest_score_student
        begin
        student = Database::DB.get_first_row("SELECT * FROM student ORDER BY diem DESC LIMIT 1")

        if student
            puts "Sinh viên điểm cao nhất: #{student['ten']}, Điểm: #{student['diem']}"
        else
            puts "Chưa có sinh viên nào!"
        end
        rescue SQLite3::SQLException => e
        puts "Lỗi SQL: #{e.message}"
        end
    end

    def filter_students_by_age(age)
        if !validate_age?(age)
        puts "Lỗi: Tuổi phải là số nguyên dương!"
        return
        end

        begin
        students = Database::DB.execute("SELECT * FROM student WHERE tuoi = ?", [age])

        if students.empty?
            puts "Không tìm thấy sinh viên nào có tuổi #{age}!"
        else
            students.each { |student| puts "Mã: #{student['ma_sv']}, Tên: #{student['ten']}, Điểm: #{student['diem']}" }
        end
        rescue SQLite3::SQLException => e
        puts "Lỗi SQL: #{e.message}"
        end
    end

    def delete_student(student_id)
        if student_id.nil? || student_id.strip.empty?
        puts "Lỗi: Mã sinh viên không được để trống!"
        return
        end

        begin
        student = Database::DB.get_first_row("SELECT * FROM student WHERE ma_sv = ?", [student_id])

        if student
            Database::DB.execute("DELETE FROM student WHERE ma_sv = ?", [student_id])
            puts "Đã xóa sinh viên có mã: #{student_id}"
        else
            puts "Không tìm thấy sinh viên để xóa!"
        end
        rescue SQLite3::SQLException => e
        puts "Lỗi SQL: #{e.message}"
        end
    end

    private

    def validate_age?(value)
        if value.is_a?(Integer) && value.positive?
        return true
        else
        return false
        end
    end

    def validate_score?(value, min, max)
        if value.is_a?(Numeric) && value >= min && value <= max
        return true
        else
        return false
        end
    end
    end
