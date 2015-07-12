include Warden::Test::Helpers
Warden.test_mode!

# Feature: Edit school form
#   As a user
#   I want to edit my school
#   So I can see edit school form
feature 'Edit school form', :school do

  # Scenario: User is not signed in
  #   When I visit the school/id/edit page
  #   Then I see message with content : You need to sign in or sign up before continuing.  
  scenario 'user can not see school(edit) form if is not signed in' do
    someSchool = 12
    visit edit_school_path(someSchool)
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  # Scenario: User can edit his school
  #   Given I am signed in
  #   When I visit the school/id/edit page
  #   Then I see my school(edit) form  
  #   School(edit) form with button 'edit school'
  scenario 'user sees school(edit) form' do
    me = FactoryGirl.create(:user, email: 'school@example.com')
    mySchool = FactoryGirl.create(:school, user_email: me.email)
    login_as(me, :scope => :user)

    visit edit_school_path(mySchool.id)
    expect(page).to have_button 'edit school'
  end

  # Scenario: User is trying to change someone else's school
  #   Given I am signed in
  #   When I visit the school/id/edit page
  #   But it is not my school id  
  #   Then I see message : 'Access denied' and root page if i have my school
  scenario 'user can not see another user school(edit) form' do
    other = FactoryGirl.create(:user, email: 'other.school@example.com')
    otherSchool = FactoryGirl.create(:school, user_email: other.email)

    me = FactoryGirl.create(:user, email: 'school@example.com')
    mySchool = FactoryGirl.create(:school, user_email: me.email)
    login_as(me, :scope => :user)

    visit edit_school_path(otherSchool.id)
    expect(page).to have_content 'Access denied'
    expect(page).to have_content 'Welcome'
  end

  # Scenario: User is trying to change someone else's school
  #   Given I am signed in
  #   When I visit the school/id/edit page
  #   But it is not my school id  
  #   Then I see message : 'School does not exists. Create school.' and new school form if i dont have my school
  scenario 'user can not see another user school(edit) form' do
    other = FactoryGirl.create(:user, email: 'other.school@example.com')
    otherSchool = FactoryGirl.create(:school, user_email: other.email)

    me = FactoryGirl.create(:user)
    login_as(me, :scope => :user)

    visit edit_school_path(otherSchool.id)
    expect(page).to have_content 'School does not exists. Create school.'
    expect(page).to have_button 'create school'
  end

  # Scenario: User can edit own school
  #   Given I am signed in
  #   When I edit my school
  #   Then I should see an success message, school name, school number of departments
  scenario 'user can edit own school' do
    user = FactoryGirl.create(:user, email: 'school@example.com')
    school = FactoryGirl.create(:school, user_email: user.email)

    login_as(user, :scope => :user)

    visit edit_school_path(school.id)

    fill_in 'Name', :with => 'Test school name'
    fill_in 'Number of departments', :with => 10

    click_button 'edit school'
    expect(page).to have_content 'School successfully updated.'
    expect(page).to have_content 'Test school name'
    expect(page).to have_content '10'
  end

end