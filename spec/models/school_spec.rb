require 'rails_helper'

RSpec.describe School, type: :model do

  it "expect to belong to user" do
    t = School.reflect_on_association(:user)
    expect(t.macro).to  eq(:belongs_to)
  end

  it "expect to have students" do
    t = School.reflect_on_association(:student)
    expect(t.macro).to  eq(:has_many)
  end

  it "expect to have departments" do
    t = School.reflect_on_association(:department)
    expect(t.macro).to  eq(:has_many)
  end
  
  let(:user) { create(:user, email: 'some.other.school@test.com') }

  it "has a valid factory" do
    expect( build(:school, user_email: user.email
    	)).to be_valid
    expect( build(:school)).not_to be_valid
  end

  let(:school) { create(:school, user_email: 'some.other.school@test.com') }
  subject {school} 

  describe "public instance methods" do
    context "responds to its methods" do
        it { should respond_to(:name) }
        it { should respond_to(:number_of_departments) }
        it { should respond_to(:user) }
        it { should respond_to(:generate_students) }
        it { should respond_to(:schedule_students) }
        it { should respond_to(:has_students?) }
        it { should respond_to(:students_are_scheduled?) }
        it { should respond_to(:departments_are_generated?) }
        it { should respond_to(:generate_departments) }
        it { should respond_to(:update_departments) }
        it { should respond_to(:get_students) }
        it { should respond_to(:get_departments) }
        it { should respond_to(:error) }
        it { should respond_to(:remove_all_data) }

    end
  end

  it { expect(school.number_of_departments).to be_a_kind_of(Numeric) }

  it "expect to be string only with letters and digits" do
     expect(school.name).to match /[A-Za-z0-9]+/
  end  

  let(:schoolWithStudents) { create(:school, :with_students, user_email: 'school.students@test.com') }
  let(:schoolWithSchedule) { create(:school, :with_schedule, user_email: 'school.schedule@test.com') }

  context "executes methods correctly" do

    context "#has_students?" do
      it "returns false if school dont have students" do
        expect(school.has_students?).to eq(false)
      end
      it "returns true if school has students" do
        expect(schoolWithStudents.has_students?).to eq(true)
      end
  end

  context "#students_are_scheduled?" do
    it "returns false if students are not scheduled" do
      expect(school.students_are_scheduled?).to eq(false)
      expect(schoolWithStudents.students_are_scheduled?).to eq(false)
    end
    it "returns true if students are scheduled" do
      expect(schoolWithSchedule.students_are_scheduled?).to eq(true)
    end
  end

  context "#departments_are_generated?" do
    it "returns false if departments are not generated (students are not scheduled)" do
      expect(school.departments_are_generated?).to eq(false)
      expect(schoolWithStudents.departments_are_generated?).to eq(false)
    end
    it "returns true if departments not generated (students are scheduled)" do
      expect(schoolWithSchedule.departments_are_generated?).to eq(true)
    end
  end

  context "#schedule_students" do
    it "returns array of students if students were not scheduled" do
      expect(schoolWithStudents.schedule_students).to be_a_kind_of(Array)
    end

    it "returns nil if students are already scheduled" do
      expect(schoolWithSchedule.schedule_students).to eq(nil)
    end
  end  
  
  context "#update_departments" do
    it "returns nil if departments are not generated" do
      expect(schoolWithSchedule.update_departments).to eq(nil)
    end
  end

  context "#get_students" do
    it "returns array of students if students were generated" do
      expect(schoolWithStudents.get_students.count).to be > 0
    end

    it "returns empty array if students are not generated" do
      expect(school.get_students.count).to eq(0)
    end
  end

  context "#get_departments" do
    it "returns array of departments if students were scheduled" do
      expect(schoolWithSchedule.get_departments.count).to be > 0
    end

    it "returns empty array if students are not scheduled" do
      expect(school.get_departments.count).to eq(0)
      expect(schoolWithStudents.get_departments.count).to eq(0)
    end
  end

  end 

  invalid_school1 = School.new(user_id:1, name:nil)

  it "must have a name" do    
    expect(invalid_school1).not_to be_valid
	  expect(invalid_school1.errors[:name].size).to eq(2)
  end

  invalid_school2 = School.new(user_id:1, name:'Some name', number_of_departments: nil)

  it "must have a number_of_departments" do    
    expect(invalid_school2).not_to be_valid
	  expect(invalid_school2.errors[:number_of_departments].size).to eq(3)
  end 

  invalid_school3 = School.new(user_id:1, name:"$%")

  it "must be a invalid valid name" do    
    expect(invalid_school3).not_to be_valid
    expect(invalid_school3.errors[:name].size).to eql(1)
  end

  invalid_school4 = School.new(user_id:1, name:'Some name', number_of_departments: 2.3)

  it "expect to be invalid digit" do    
    expect(invalid_school4).not_to be_valid
    expect(invalid_school4.errors[:number_of_departments].size).to eq(1)
  end

  invalid_school5 = School.new(user_id:1, name:'Some name', number_of_departments: 0)

  it "expect to be invalid digit" do    
    expect(invalid_school5).not_to be_valid
    expect(invalid_school5.errors[:number_of_departments].size).to eq(1)
  end

end
