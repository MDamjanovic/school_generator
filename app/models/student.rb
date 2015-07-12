class Student < ActiveRecord::Base
  belongs_to :school
  belongs_to :department

  validates :school_id, :presence => true
  validates :name, :presence => true
  validates :gender, :presence => true
  validates :gender, :format => { with: /((fe)?male)/ }

  def department
  	Department.find(self.department_id).number if Department.exists?(self.department_id)
  end

end
