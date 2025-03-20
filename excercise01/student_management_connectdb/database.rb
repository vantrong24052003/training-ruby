require 'sqlite3'

module Database
  DB = SQLite3::Database.new 'student_management.db'
  DB.results_as_hash = true

  def self.setup
    DB.execute <<-SQL
      CREATE TABLE IF NOT EXISTS student (
        ma_sv TEXT PRIMARY KEY,
        ten TEXT,
        tuoi INTEGER,
        diem REAL
      );
    SQL

    seed_data if table_empty?
  end

  def self.table_empty?
    DB.get_first_value("SELECT COUNT(*) FROM student").to_i == 0
  end

  def self.seed_data
    sample_students = [
      { ma_sv: "SV001", ten: "Nguyễn Văn A", tuoi: 20, diem: 8.5 },
      { ma_sv: "SV002", ten: "Trần Thị B", tuoi: 21, diem: 7.8 },
      { ma_sv: "SV003", ten: "Lê Văn C", tuoi: 22, diem: 9.2 },
      { ma_sv: "SV004", ten: "Phạm Thị D", tuoi: 20, diem: 6.5 }
    ]

    sample_students.each do |sv|
      DB.execute("INSERT INTO student (ma_sv, ten, tuoi, diem) VALUES (?, ?, ?, ?)", [sv[:ma_sv], sv[:ten], sv[:tuoi], sv[:diem]])
    end

    puts "Thêm data thành công!"
  end
end
