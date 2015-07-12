describe SchoolPolicy do
  subject { SchoolPolicy }

  let(:user)          { FactoryGirl.create(:user, email: 'school@example.com')}
  let(:otherUser)     { FactoryGirl.create(:user) }
  let(:school)        { FactoryGirl.create(:school, user_email: user.email) }

  permissions :authorized? do
    it "denies access if not owner" do
      expect(subject).not_to permit(school,otherUser)
    end
    it "allows access for owner" do
      expect(subject).to permit(school,user)
    end
  end
end