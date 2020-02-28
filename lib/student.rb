require 'pry'
class Student
  attr_accessor :id, :name, :grade
  def initialize(id = nil,name = nil,grade=nil)
    @id = id
    @name = name
    @grade = grade
  end

  def self.new_from_db(row)
    Student.new(row[0],row[1],row[2])
  end

  def self.all
    sql = <<-SQL
          SELECT * FROM students
          SQL
          DB[:conn].execute(sql).map do |student|
            self.new_from_db(student)
          end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ? LIMIT 1
      SQL
      arr = DB[:conn].execute(sql, name)[0]
      self.new_from_db(arr)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
  def self.all_students_in_grade_9
    self.all.select do |student|
      student.grade == "9"
    end
  end
  def self.students_below_12th_grade
    self.all.select do |student|
      student.grade.to_i < 12
    end
  end
  def self.first_X_students_in_grade_10(num_students)
    grade10 = self.all.select do |student|
      student.grade == "10"
    end
    grade10.slice(0,num_students)
  end
  def self.first_student_in_grade_10
    grade10 = self.all.select do |student|
      student.grade == "10"
    end
    grade10[0]
  end
  def self.all_students_in_grade_X(some_grade)
    self.all.select do |student|
      student.grade.to_i == some_grade
    end
  end
end
