class SchoolPolicy

  attr_reader :user, :school

  def initialize(school,user)
    @user = user
    @school = school
  end

  def authorized?
    @school.user_id == @user.id
  end
end