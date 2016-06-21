require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
    # create a new Student object given a row from the database
  end

  def self.all
    sql = "SELECT * FROM students"
    all = DB[:conn].execute(sql).map do |row|
      new_from_db(row)
    end
    all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.students_below_12th_grade 
    DB[:conn].execute("SELECT * FROM STUDENTS WHERE grade < 12").map{|row| new_from_db(row)}
  end



  def self.count_all_students_in_grade_9
    self.all.select {|object| object.grade.to_i == 9}
  end

  def self.first_x_students_in_grade_10(num)
    tens = self.all.select{|object| object.grade.to_i == 10 }
    tens[0..num - 1]
  end

  def self.first_student_in_grade_10
    student = self.all.find{|object| object.grade.to_i == 10}
  end

  def self.all_students_in_grade_X(num)
    self.all.select{|object| object.grade.to_i == num}
  end

  def self.find_by_name(student_name)
    sql = "SELECT * FROM students"

    student = DB[:conn].execute(sql).find do |row|
      row.include?(student_name)
      end 

    new_from_db(student)
    # find the student in the database given a name
    # return a new instance of the Student class
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
end
