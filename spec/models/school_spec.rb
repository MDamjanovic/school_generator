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


  let(:school) { build(:school, user_email: 'some.other.school@test.com') }

  subject {school}

  it { should respond_to(:name) }
  it { should respond_to(:number_of_departments) }
  it { should respond_to(:user) }
  it { should respond_to(:generate_students) }
  it { should respond_to(:schedule_students) }

  it { expect(school.number_of_departments).to be_a_kind_of(Numeric) }

  it "expect to be string only with letters and digits" do
     expect(school.name).to match /[A-Za-z0-9]+/
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
