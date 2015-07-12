describe StudentPolicy do
  subject { StudentPolicy }

  let(:user)          { FactoryGirl.create(:user, email: 'user1@example.com')}
  let(:school)        { FactoryGirl.create(:school, user_email: user.email) }
  let(:student)       { FactoryGirl.create(:student, students_school: school.id) }

  let(:otherUser)          { FactoryGirl.create(:user, email: 'user2@example.com')}
  let(:otherSchool)        { FactoryGirl.create(:school, user_email: user.email) }


  permissions :update? do
    it "denies access if doesn't belong to school" do
      expect(subject).not_to permit(otherSchool,student)
    end
    it "allows access if belongs to school" do
      expect(subject).to permit(school,student)
    end
  end  

end

