require 'faker'

FactoryGirl.define do
  factory :school do
  	name Faker::Name.first_name << " " << Faker::Name.last_name
  	number_of_departments 10

  	transient do
    	user_email nil
  	end
 
  	user_id do
    	user = (User.find_by(email: user_email) || create(:user, email:user_email)) unless user_email.nil?
    	user.nil?? nil : user.id 
  	end

    trait :with_students do
      after(:create) do |school|
        create_list(:student, 10, students_school: school.id)
      end
    end

    trait :with_schedule do
      after(:create) do |school|
        10.times{ |i|
          i += 1
          department = FactoryGirl.create(:department, num: i, school: school.id)
          FactoryGirl.create(:student, students_school: school.id, students_department: department.id)
        }
      end
    end
	end
end  