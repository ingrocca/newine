class User < ActiveRecord::Base
	has_many :tags
	has_many :servings

	def permissions=(val)

		case val
		when 'customer'
			can_clean = false
			can_detach = false
			can_set_temp = false
		when 'employee'
			can_clean = false
			can_detach = false
			can_set_temp = false
		when 'manager'
			can_clean = true
			can_detach = true
			can_set_temp = true
		end
	end

end