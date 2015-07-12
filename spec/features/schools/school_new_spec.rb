include Warden::Test::Helpers
Warden.test_mode!

# Feature: New school form
#   As a user
#   I want to create my school
#   So I can see school form
feature 'New school form', :school do

  # Scenario: User is not signed in
  #   When I visit the school/new page
  #   Then I see message with content : You need to sign in or sign up before continuing.  
  scenario 'user can not see school(new) form if is not signed in' do
    visit new_school_path(School.new)
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  # Scenario: User sees school(new) form
  #   Given I am signed in
  #   When I visit the school/new page
  #   Then I see my school(new) form if i haven't already created school 
  #   School(new) form with button 'create school'
  scenario 'user sees school(new) form' do
    me = FactoryGirl.create(:user, email: 'school@example.com')
    login_as(me, :scope => :user)
    visit new_school_path
    expect(page).to have_button 'create school'
  end

  # Scenario: User sees school(edit) form
  #   Given I am signed in
  #   When I visit the school/new page
  #   Then I see my school(edit) form if i have already created school 
  #   School(edit) form with button 'edit school' and message with content: You're already created school
  scenario "user sees school school(edit) form because he already has created school" do
    me = FactoryGirl.create(:user, email: 'school@example.com')
    mySchool = FactoryGirl.create(:school, user_email: me.email)
    login_as(me, :scope => :user)
    visit new_school_path
    expect(page).to have_button 'edit school'
    expect(page).to have_content "You're already created school"
  end

  # Scenario: User can create own school
  #   Given I am signed in
  #   When I create my school
  #   Then I should see an success message, school name, school number of departments, and button 'generate students'
  scenario 'user can create own school' do
    user = FactoryGirl.create(:user, email: 'school@example.com')
    login_as(user, :scope => :user)

    visit new_school_path
    fill_in 'Name', :with => 'Test school name'
    fill_in 'Number of departments', :with => 10

    click_button 'create school'
    expect(page).to have_content 'School was successfully created.'
    expect(page).to have_content 'Test school name'
    expect(page).to have_content '10'
    expect(page).to have_button 'generate students'
  end
end
