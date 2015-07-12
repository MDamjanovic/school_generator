# Feature: Home page
#   As a visitor
#   I want to visit a home page
#   So I can learn more about the website
feature 'Home page' do

  # Scenario: Visit the home page
  #   Given I am a visitor
  #   When I visit the home page
  #   Then I see "Welcome"
  scenario 'visit the home page' do
    visit root_path
    expect(page).to have_content 'Welcome'
  end

  # Scenario: Visit the home page
  #   Given I am signed in as user
  #   When I visit the home page
  #   Then If didn't create school I see 'generate school'
  scenario 'user sees option to create school' do
    user = FactoryGirl.create(:user)
    login_as(user, scope: :user)
    visit root_path
    expect(page).to have_content 'Generate school'
  end

  # Scenario: Visit the home page
  #   Given I am signed in as user
  #   When I visit the home page
  #   Then If created school I see 'You're already create school:' and school name
  scenario 'user sees option to create school' do
    user = FactoryGirl.create(:user, email: 'school@example.com')
    login_as(user, :scope => :user)
    school = FactoryGirl.create(:school, user_email: user.email)
    visit root_path
    expect(page).to have_content "You're already created school:"
    expect(page).to have_content school.name
  end

end
