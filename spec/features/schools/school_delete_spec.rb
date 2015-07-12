include Warden::Test::Helpers
Warden.test_mode!

# Feature: Delete school 
#   As a user
#   I want to delete my school
feature 'Delete school form', :school, :js do

  # Scenario: User can delete own school
  #   Given I am signed in
  #   When I delete my school
  #   Then I should see an school deleted message
  scenario 'user can delete own account' do
    user = FactoryGirl.create(:user, email: 'school@example.com')
    school = FactoryGirl.create(:school, user_email: user.email)
    login_as(user, :scope => :user)

    visit school_path(school.id)
    click_link 'Delete'
    page.driver.browser.switch_to.alert.accept
    expect(page).to have_content 'School was successfully destroyed.'
  end

end
