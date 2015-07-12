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

  it { expect(department.number).to be_a_kind_of(Numeric) }

  it { should respond_to(:number) }
  it { should_not respond_to(:generate_students) }
  it { should_not respond_to(:schedule_students) }
  
end
