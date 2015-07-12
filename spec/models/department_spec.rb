require 'rails_helper'

RSpec.describe Department, type: :model do

  it "expect to belong to school" do
    t = Department.reflect_on_association(:school)
    expect(t.macro).to  eq(:belongs_to)
  end

  it "expect to have students" do
    t = Department.reflect_on_association(:student)
    expect(t.macro).to  eq(:has_many)
  end

  it "has a valid factory" do
    expect( build(:department, num: 1, school: 1)).to be_valid
    expect( build(:department, school: 1)).not_to be_valid
    expect( build(:department, num: 1)).not_to be_valid
  end

  let(:department) { build(:department, school: 1, num: 1) }

  subject {department}

  describe "public instance methods" do
    context "responds to its methods" do
        it { expect(department.number).to be_a_kind_of(Numeric) }
        it { should respond_to(:number) }
    end
  end 

  it { expect(department.number).to be_a_kind_of(Numeric) }

  invalid_department1 = Department.new(number: 1)
  it "must have a school" do    
    expect(invalid_department1).not_to be_valid
    expect(invalid_department1.errors[:school_id].size).to eql(1)
  end

  invalid_department2 = Department.new(school_id: 1)
  it "must have a number" do    
    expect(invalid_department2).not_to be_valid
  end
  
end
