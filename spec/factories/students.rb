FactoryGirl.define do
  factory :student do
    name "MyString"
	  gender "male"
	  with_special_needs false

	  transient do
    	students_school nil
    	students_department nil
  	end
 
  	school_id do
    	students_school
  	end

    department_id do
      students_department
    end
  end
end