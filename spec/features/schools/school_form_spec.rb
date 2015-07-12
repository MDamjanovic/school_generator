include Warden::Test::Helpers
Warden.test_mode!

# Feature: New/Edit school form
#   As a user
#   I want to create/edit my school
#   So I can see school form
feature 'Check school form input', :school do

  # Scenario: User must fill in field Name and in field Number of departments
  #   Given I am signed in
  #   When I create my school without name or without number of departments
  #   Then I should see an error 'can't be blank.'
  scenario 'user can not create school if name or number of departments are blank' do
    user = FactoryGirl.create(:user, email: 'school@example.com')
    login_as(user, :scope => :user)

    visit new_school_path
    fill_in 'Name', :with => ''
    fill_in 'Number of departments', :with => 10
    click_button 'create school'
    expect(page).to have_content "Name can't be blank."
    
    fill_in 'Name', :with => 'Test school name'
    fill_in 'Number of departments', :with => ''
    click_button 'create school'
    expect(page).to have_content "Number of departments can't be blank."
  end

  # Scenario: User must fill in field Name and in field Number of departments
  #   Given I am signed in
  #   When I edit my school without name or without number of departments
  #   Then I should see an error 'can't be blank.'
  scenario 'user can not edit school if name or number of departments are blank' do
    user = FactoryGirl.create(:user, email: 'school@example.com')
    school = FactoryGirl.create(:school, user_email: user.email)
    login_as(user, :scope => :user)

    visit edit_school_path(school.id)
    fill_in 'Name', :with => ''
    fill_in 'Number of departments', :with => 10
    click_button 'edit school'
    expect(page).to have_content "Name can't be blank."
    
    fill_in 'Name', :with => 'Test school name'
    fill_in 'Number of departments', :with => ''
    click_button 'edit school'
    expect(page).to have_content "Number of departments can't be blank."
  end

  # Scenario: User trying to create school with invalid input
  #   Given I am signed in
  #   When I create my school with invalid name or with invalid number of departments
  #   Then I should see an error 'has invalid format.'
  scenario 'user can not create school if name or number of departments has invalid format' do
    user = FactoryGirl.create(:user, email: 'school@example.com')
    login_as(user, :scope => :user)

    visit new_school_path

    array = 33...126
    array.each do |c| 
    	c = c.chr(Encoding::UTF_8)
    	unless c.match(/^[[:alpha:]]$/) || c.match(/^[[:digit:]]$/)
		    fill_in 'Name', :with => c
		    fill_in 'Number of departments', :with => 10
		    click_button 'create school'
		    expect(page).to have_content "Name has invalid format."
		end

	    unless c.match(/^[[:digit:]]$/) && c.to_i != 0
	    	fill_in 'Name', :with => 'Test school name'
	    	fill_in 'Number of departments', :with => c
	    	click_button 'create school'
	    	if c.to_i == 0
	    		expect(page).to have_content "Number of departments must be greater than 0."
	    	else	
	    		expect(page).to have_content "Number of departments has invalid format."
	    	end
    	end
    end
  end

  # Scenario: User trying to create school with invalid input
  #   Given I am signed in
  #   When I create my school with invalid name or with invalid number of departments
  #   Then I should see an error 'has invalid format.'
  scenario 'user can not edit school if name or number of departments has invalid format' do
    user = FactoryGirl.create(:user, email: 'school@example.com')
    school = FactoryGirl.create(:school, user_email: user.email)
    login_as(user, :scope => :user)

    visit edit_school_path(school.id)

    array = 33...126
    array.each do |c| 
    	c = c.chr(Encoding::UTF_8)
    	unless c.match(/^[[:alpha:]]$/) || c.match(/^[[:digit:]]$/)
		    visit new_school_path
		    fill_in 'Name', :with => c
		    fill_in 'Number of departments', :with => 10
		    click_button 'edit school'
		    expect(page).to have_content "Name has invalid format."
		end

	    unless c.match(/^[[:digit:]]$/) && c.to_i != 0
	    	fill_in 'Name', :with => 'Test school name'
	    	fill_in 'Number of departments', :with => c
	    	click_button 'edit school'
	    	if c.to_i == 0
	    		expect(page).to have_content "Number of departments must be greater than 0."
	    	else	
	    		expect(page).to have_content "Number of departments has invalid format."
	    	end
    	end
    end
  end

end