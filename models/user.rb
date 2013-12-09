class User < ActiveRecord::Base
	has_many :tags
	has_many :servings

	def permissions=(val)

		case val
		when 'customer'
			can_clean = false
			can_detach = false
			can_set_temp = false
		when 'superclient'
			can_clean = false
			can_detach = false
			can_set_temp = false
		when 'employee'
			can_clean = true
			can_detach = true
			can_set_temp = true
		when 'manager'
			can_clean = true
			can_detach = true
			can_set_temp = true
		end

		self.client_type = val
	end

	def client_type_human
		case client_type
		when 'customer'
			'Cliente'
		when 'superclient'
			'SuperCliente'
		when 'employee'
			'Empleado'
		when 'manager'
			'Gerente'
		end

	end

end