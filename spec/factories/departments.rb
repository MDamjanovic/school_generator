FactoryGirl.define do
  factory :department do

  	transient do
    	num nil
    	school nil
  	end

  	number { num }
  	school_id { school }

  end
end
