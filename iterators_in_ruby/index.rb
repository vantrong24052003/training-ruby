# frozen_string_literal: true

# each: duyệt qua các phần tử nhưng không tạo mảng mới
numbers = [1, 2, 3]
numbers.each do |value|
  value * 2
  value * 2
end
# puts numbers # => [1, 2, 3]

# map: tạo ra mảng mới với các phần tử được biến đổi
numbers = [1, 2, 3]
numbers.map { |value| value * 2 }
# puts new_numbers # => [2, 4, 6]

# select: giữ lại các phần tử thỏa mãn điều kiện
numbers = [1, 2, 3, 4]
numbers.select(&:even?)
# puts even_numbers # => [2, 4]

# reject: loại bỏ các phần tử thỏa mãn điều kiện
numbers = [1, 2, 3, 4]
numbers.reject(&:odd?)
# puts odd_numbers # => [2, 4]

# find: tìm phần tử đầu tiên thỏa mãn điều kiện
students = [{ name: 'An', grade: 8 }, { name: 'Bình', grade: 9 }]
students.find { |value| value[:grade] == 9 }
# puts student_with_grade_9 # => {:name=>"Bình", :grade=>9}
