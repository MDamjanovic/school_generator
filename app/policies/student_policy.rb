class StudentPolicy

  attr_reader :school
  attr_reader :student

  def initialize(school, student)
    @school = school
    @student = student
  end

  def update?
    @student.school_id == @school.id
  end

end