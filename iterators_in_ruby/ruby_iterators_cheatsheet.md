# Ruby Iterators – Hướng dẫn cho người mới bắt đầu

> Đây là tài liệu giúp bạn **hiểu rõ** cách dùng các iterator trong Ruby,
> với giải thích dễ hiểu, ví dụ trực quan và ghi nhớ nhanh.

---

## 1. Cơ bản

### `each` – Duyệt từng phần tử
**Khi dùng:** Khi muốn **làm gì đó với từng phần tử** mà không cần tạo mảng mới.

**Ví dụ:**
```ruby
numbers = [1, 2, 3]

numbers.each do |num|
  puts "Số hiện tại: #{num}"
end
```
**Kết quả:**
```
Số hiện tại: 1
Số hiện tại: 2
Số hiện tại: 3
```
**Ghi nhớ:** `each` = chỉ để làm việc, không tạo mảng mới.

---

### `each_with_index` – Duyệt kèm số thứ tự
**Khi dùng:** Khi cần biết **phần tử và vị trí** của nó.

```ruby
fruits = ["Táo", "Chuối", "Cam"]
fruits.each_with_index do |fruit, index|
  puts "#{index} - #{fruit}"
end
```
**Kết quả:**
```
0 - Táo
1 - Chuối
2 - Cam
```

---

### `map` / `collect` – Biến đổi mảng, trả về mảng mới
**Khi dùng:** Khi muốn **tạo ra mảng mới** từ mảng cũ.

```ruby
numbers = [1, 2, 3]
squared = numbers.map { |n| n**2 }
puts squared.inspect
```
**Kết quả:**
```
[1, 4, 9]
```

---

### `flat_map` – Biến đổi + gộp 1 cấp
**Khi dùng:** Khi mỗi phần tử biến thành mảng con, và bạn muốn gộp chúng lại.

```ruby
numbers = [1, 2]
result = numbers.flat_map { |n| [n, n * 2] }
puts result.inspect
```
**Kết quả:**
```
[1, 2, 2, 4]
```

---

### `select` / `filter` – Giữ lại phần tử đúng điều kiện
```ruby
numbers = [1, 2, 3, 4]
even_numbers = numbers.select { |n| n.even? }
puts even_numbers.inspect
```
**Kết quả:**
```
[2, 4]
```

---

### `reject` – Loại bỏ phần tử đúng điều kiện
```ruby
numbers = [1, 2, 3]
not_odd = numbers.reject { |n| n.odd? }
puts not_odd.inspect
```
**Kết quả:**
```
[2]
```

---

### `find` / `detect` – Tìm phần tử đầu tiên đúng điều kiện
```ruby
people = [{name: "An", age: 17}, {name: "Bình", age: 22}]
adult = people.find { |p| p[:age] >= 18 }
puts adult.inspect
```
**Kết quả:**
```
{:name=>"Bình", :age=>22}
```

---

### `any?` – Có ít nhất 1 phần tử đúng điều kiện
```ruby
[1, 2, 3].any? { |n| n.even? }
# => true
```

---

### `all?` – Tất cả phần tử đều đúng điều kiện
```ruby
[2, 4, 6].all? { |n| n.even? }
# => true
```

---

### `none?` – Không có phần tử nào đúng điều kiện
```ruby
[1, 3, 5].none? { |n| n.even? }
# => true
```

---

### `one?` – Chỉ đúng 1 phần tử đúng điều kiện
```ruby
[1, 2, 3].one? { |n| n.even? }
# => true
```

---

### `group_by` – Chia nhóm phần tử
```ruby
words = ["cat", "car", "dog"]
grouped = words.group_by { |w| w[0] }
puts grouped.inspect
```
**Kết quả:**
```
{"c"=>["cat", "car"], "d"=>["dog"]}
```

---

### `zip` – Ghép nhiều mảng
```ruby
numbers = [1, 2]
letters = ["a", "b"]
puts numbers.zip(letters).inspect
```
**Kết quả:**
```
[[1, "a"], [2, "b"]]
```

---

### `each_slice` – Cắt mảng thành nhóm đều nhau
```ruby
(1..6).each_slice(2) { |slice| p slice }
```
**Kết quả:**
```
[1, 2]
[3, 4]
[5, 6]
```

---

### `each_cons` – Nhóm các phần tử liền nhau
```ruby
(1..4).each_cons(2) { |pair| p pair }
```
**Kết quả:**
```
[1, 2]
[2, 3]
[3, 4]
```

---

## 2. Kết hợp (Chaining)

### `filter.all?`
```ruby
[2, 4, 6].filter(&:even?).all? { |n| n > 0 }
# => true
```

### `filter.any?`
```ruby
[1, 12, 15].filter { |n| n > 10 }.any?(&:even?)
# => true
```

### `map.all?`
```ruby
people = [{age: 18}, {age: 22}]
people.map { |p| p[:age] }.all? { |age| age >= 18 }
# => true
```

### `map.any?`
```ruby
%w[ruby rails].map(&:length).any? { |len| len >= 5 }
# => true
```

---

## 3. Bang methods – Thay đổi trực tiếp mảng gốc

### `map!`
```ruby
a = [1, 2]
a.map! { |n| n * 10 }
puts a.inspect
# => [10, 20]
```

### `select!` / `filter!`
```ruby
b = [1, 2, 3, 4]
b.select!(&:even?)
puts b.inspect
# => [2, 4]
```

### `reject!`
```ruby
c = [1, 2, 3]
c.reject!(&:odd?)
puts c.inspect
# => [2]
```

### `compact!`
```ruby
arr = [1, nil, 2, nil, 3]
arr.compact!
puts arr.inspect
# => [1, 2, 3]
```

### `uniq!`
```ruby
arr = [1, 2, 2, 3, 3, 3]
arr.uniq!
puts arr.inspect
# => [1, 2, 3]
```

---
**Tip cuối:**
- Dùng `each` khi **chỉ muốn làm gì đó với từng phần tử**.
- Dùng `map` khi **muốn tạo mảng mới**.
- Dùng `select`/`reject` khi **lọc dữ liệu**.
- Dùng `!` (bang methods) khi **muốn thay đổi mảng gốc**.
