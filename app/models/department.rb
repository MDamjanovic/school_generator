class Department < ActiveRecord::Base
  belongs_to :school
  has_many :student,:through => :school

  validates :school_id, :presence =>  true
  
  validates :number, :presence =>  true
  validates :number, :numericality => {:greater_than => 0  }
  validates :number, :numericality => {:only_integer => true } 
end
