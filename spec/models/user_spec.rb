describe User do

  before(:each) { @user = User.new(email: 'user@example.com') } 

  subject { @user }

  it { should respond_to(:email) }
  it { should respond_to(:added_school?) }
  it { should respond_to(:users_school) }

  it "#email returns a string" do
    expect(@user.email).to match 'user@example.com'
  end

 let(:user) { create(:user, :with_school, email: 'school@example.com') }

 context "executes methods correctly" do

    context "#added_school?" do
      it "returns false if user does not created school" do
        expect(@user.added_school?).to eq(false)
      end
      it "returns true if user has school" do
        expect(user.added_school?).to eq(true)
      end
  	end
    context "#users_school" do
      it "returns nil if school does not exists" do
        expect(@user.users_school).to eq(nil)
      end
      it "returns users school if user has school" do
        expect(user.users_school).to be_a_kind_of(School)
      end
  	end
end

end
