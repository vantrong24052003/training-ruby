require_relative 'person'

class Student < Person
  attr_accessor :student_id, :score

  def initialize(student_id, name, age, score)
    super(name, age)
    @student_id = student_id
    @score = score
  end
end
