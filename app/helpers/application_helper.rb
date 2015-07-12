module ApplicationHelper

	def policy(record,suspicious)
  		"#{record.class}Policy".constantize.new(record, suspicious)
	end
	
end
