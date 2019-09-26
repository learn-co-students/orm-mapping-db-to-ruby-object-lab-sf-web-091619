class Student
  attr_accessor :id, :name, :grade

  # def initialize(id:, name:, grade:)
  #   @id = id
  #   @name = name
  #   @grade = grade
  # end

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    # binding.pry
    ns = self.new
    ns.id = row[0]
    ns.name = row[1]
    ns.grade = row[2]
    ns
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    DB[:conn].execute("SELECT * FROM students").map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    DB[:conn].execute("SELECT * FROM students WHERE name = ? LIMIT 1", name).map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.all_students_in_grade_9
    DB[:conn].execute("SELECT * FROM students WHERE grade = 9").map do |row|
      self.new_from_db(row)
    end
  end

  def self.students_below_12th_grade
    DB[:conn].execute("SELECT * FROM students WHERE grade < 12 LIMIT 1").map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_X_students_in_grade_10(x)
    DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT ?", x).map do |row|
      self.new_from_db(row)
    end
  end

  def self.all_students_in_grade_X(x)
    DB[:conn].execute("SELECT * FROM students WHERE grade = ?", x).map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_student_in_grade_10
    DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT 1").map do |row|
      self.new_from_db(row)
    end.first
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
