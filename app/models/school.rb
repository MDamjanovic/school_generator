require 'faker'

class School < ActiveRecord::Base
	belongs_to :user
	has_many :department
	has_many :student

	validates :user_id, :presence => true

    validates :name, :presence => { :message => "can't be blank." }
    validates :name, :format => { with: /[A-Za-z0-9]+/, :message => "has invalid format."} 

	validates :number_of_departments, :presence => {:message => "can't be blank."}
    validates :number_of_departments, :numericality => {:greater_than => 0, :message => "must be greater than 0." }
    validates :number_of_departments, :numericality => {:only_integer => true, :message => "has invalid format." }

	def error
		errors.full_messages.first if  errors.full_messages.any?
	end

	def has_students?
		Student.exists?(:school_id => self.id)
  	end

  	def students_are_scheduled?
  		Student.joins(:department).any?
  	end

  	def get_students
  		has_students?? Student.where(:school_id => self.id) : []
  	end

  	def get_departments
  		departments_are_generated?? Department.where(:school_id => self.id) : []
  	end

  	def generate_students
  		return if has_students?
		#number of students
		num = 90 + Random.rand(21)

		#generate random gender(0-male, 1-female) and add student
		num.times{ 
		    gender = Random.rand(2) % 2 == 0? "male" : "female" 
		    params = {
		        :name => Faker::Name.first_name,
		        :gender => gender,
		        :school_id => self.id
		    }
		student = Student.new(params);
		student.save		
		}
  	end

  	def schedule_students

  		return if students_are_scheduled?

  		generate_departments

  		students = get_students
  		departments =  get_departments

	    #last added gender
	    gender = students[0].gender
	    #current department
	    curr = -1
	    #number of departments
	    modul = departments.count
	    #add maximum two students in a departmen one after the other
	    added = false;

	    #complexity O(n)
	    students.each{ |student|
	        # on first enter will be true ==> curr >= 0
	        # one student is already added (last added gender)
	        if added

	            curr += 1
	            added = false
	            gender = student.gender

	        elsif student.gender.eql? gender
	            curr += 1
	        else
	            gender = student.gender
	            added = true
	        end
	        student.update_attribute(:department_id , departments[curr % modul].id)
	    }
  	end

  	def departments_are_generated?
  		Department.exists?(:school_id => self.id)
  	end

  	def generate_departments
  		return if departments_are_generated?

	    self.number_of_departments.times{ |number|
	       	number += 1
	        params = {
	            :number => number,
	            :school_id => self.id
	        }
	        department = Department.new(params)
	        department.save
	    }
  	end

  	def update_departments
  		return unless departments_are_generated?
  		unless self.number_of_departments == get_departments.count || !has_students?

		    Department.where(:school_id => self.id).each { |department| 

		        Student.where(:department_id => department.id).each { |student|

		        	student.update_attribute(:department_id , nil)
		        }

		     department.destroy
		    }
		  	schedule_students
		end
  	end

  	def remove_all_data
  		departments = get_departments
  		students = get_students

  		departments.each{ |department|
  			department.destroy
  		}
    	students.each{ |student|
  			student.destroy
  		}
    	self.destroy
  	end
end
