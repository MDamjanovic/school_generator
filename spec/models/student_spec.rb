require 'rails_helper'

RSpec.describe Student, type: :model do

  it "expect to belong to school" do
    t = Student.reflect_on_association(:school)
    expect(t.macro).to  eq(:belongs_to)
  end

  it "expect to belong to department" do
    t = Student.reflect_on_association(:department)
    expect(t.macro).to  eq(:belongs_to)
  end

  it "has a valid factory" do
    expect(build(:student, students_school: 1, students_department: 2)).to be_valid
    expect(build(:student, students_school: 1)).to be_valid
    expect(build(:student)).not_to be_valid
  end

  let(:user) { build(:user, email: 'some.other.school@test.com') }
  let(:school) { build(:school, user_email: 'some.other.school@test.com') }
  let(:student) { build(:student, students_school: school.id )}

  subject {student}

  it { should respond_to(:name) }
  it { should respond_to(:gender) }
  it { should respond_to(:with_special_needs) }
  it { should_not respond_to(:generate_students) }
  it { should_not respond_to(:schedule_students) }

  invalid_student = Student.new(name: "Name", school_id: 1)
  it "must have a gender" do    
    expect(invalid_student).not_to be_valid
    expect(invalid_student.errors[:gender].size).to eql(2)
  end

  it "expect to be male or female" do
     expect(student.gender).to match  /((fe)?male)/
  end  

end
