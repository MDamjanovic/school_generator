require 'faker'

FactoryGirl.define do
  factory :school do
  	name Faker::Name.first_name << " " << Faker::Name.last_name
  	number_of_departments 10

  	transient do
    	user_email nil
  	end
 
  	user_id do
    	user = User.find_by(email: user_email)
    	user.nil?? nil : user.id 
  	end
	end
end  