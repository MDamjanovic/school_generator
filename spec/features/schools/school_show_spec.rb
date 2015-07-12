include Warden::Test::Helpers
Warden.test_mode!

# Feature: School page
#   As a user
#   I want to see my school page
#   So I can see my school data
feature 'School page', :school do

  # Scenario: User cannot school page
  #   When I visit the school page
  #   Then I see message 'You need to sign in or sign up before continuing.'
  scenario 'user is not signed in and he cant see school page' do
    user = FactoryGirl.create(:user, email: 'school@example.com')
    school = FactoryGirl.create(:school, user_email: user.email)
    visit school_path(school.id)

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(page).not_to have_content school.name
    expect(page).not_to have_content school.number_of_departments
  end


  # Scenario: User sees own school page
  #   Given I am signed in
  #   When I visit the school page
  #   Then I see my school data
  scenario 'user sees own school page' do
    user = FactoryGirl.create(:user, email: 'school@example.com')
    login_as(user, :scope => :user)
    school = FactoryGirl.create(:school, user_email: user.email)
    visit school_path(school.id)
    expect(page).to have_content school.name
    expect(page).to have_content school.number_of_departments
  end

  # Scenario: User cannot see another user's school page
  #   Given I am signed in
  #   And I have my own school
  #   When I visit another user's school page
  #   Then I see an 'Access denied.' message and my home page
  scenario "user cannot see another user's school page" do
    me = FactoryGirl.create(:user, email: 'school@example.com')
    mySchool = FactoryGirl.create(:school, user_email: me.email)

    other = FactoryGirl.create(:user, email: 'other.school@example.com')
    otherSchool = FactoryGirl.create(:school, user_email: other.email)

    login_as(me, :scope => :user)
    visit school_path(otherSchool.id)
    expect(page).to have_content 'Access denied.'
    expect(page).to have_content 'Welcome'
    expect(page).to have_content "You're already created school:"
    expect(page).to have_content mySchool.name
  end

  # Scenario: User cannot see another user's school page
  #   Given I am signed in
  #   And I don't have my own school
  #   When I visit another user's school page
  #   Then I see an 'School does not exists. Create school.' message and create school
  scenario "user cannot see another user's school page, but he can create his own" do
    other = FactoryGirl.create(:user, email: 'school@example.com')
    otherSchool = FactoryGirl.create(:school, user_email: other.email)

    me = FactoryGirl.create(:user, email: 'other@example.com')
    login_as(me, :scope => :user)
    visit school_path(otherSchool.id)
    expect(page).to have_content 'School does not exists. Create school.'
  end

  # Scenario: User sees own school page
  #   Given I am signed in
  #   User has not generated students
  #   Then I see 'generate students' button
  #   And , after click , I cant see that button anymore
  #   I see button 'schedule students', students table and message : 'Students were successfully generated.'
  scenario 'user sees own school page and generated students' do
    user = FactoryGirl.create(:user, email: 'school@example.com')
    login_as(user, :scope => :user)
    school = FactoryGirl.create(:school, user_email: user.email)

    visit school_path(school.id)
    click_button 'generate students'

    expect(page).to have_content 'Students were successfully generated.'
    expect(page).to have_content 'With special needs'
    expect(page).not_to have_button 'generate students'
    expect(page).to have_button 'schedule students'
  end

  # Scenario: User sees own school page
  #   Given I am signed in
  #   User generated students
  #   Then I see 'schedule students' button
  #   And , after click , I cant see that button anymore
  #   I see message : 'Students were successfully scheduled.'
  scenario 'user sees own school page and scheduled students' do
    user = FactoryGirl.create(:user, email: 'school@example.com')
    school = FactoryGirl.create(:school, user_email: user.email)
    login_as(user, :scope => :user)

    visit school_path(school.id)
    click_button 'generate students'
    click_button 'schedule students'

    expect(page).to have_content 'Students were successfully scheduled.'
    expect(page).not_to have_button 'schedule students'
  end

end
