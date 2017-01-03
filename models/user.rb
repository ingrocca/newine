class User < ActiveRecord::Base
	has_many :tags, dependent: :destroy
	has_many :servings
	belongs_to :category
	has_many :complementary_drinks

	validates :client_type, inclusion: { in: %w(customer employee manager), message: "%{value} no es un tipo válido"}
	validates :name, :presence=>true
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, format: { with: VALID_EMAIL_REGEX }, :allow_blank => true


	def to_s
		"#{name} #{surname}"
	end
	
	def permissions=(val)
		case val
		when 'customer'
			self.can_clean = false
			self.can_detach = false
			self.can_set_temp = false
		when 'employee'
			self.can_clean = true
			self.can_detach = true
			self.can_set_temp = true
			self.category_id = nil
		when 'manager'
			self.can_clean = false
			self.can_detach = false
			self.can_set_temp = false
			self.category_id = nil
		end
		self.client_type = val
	end

	def client_type_human
		case client_type
		when 'customer'
			'Cliente'
		when 'employee'
			'Empleado'
		when 'manager'
			'Gerente'
		end
	end

	def current_tag
		tag = tags.last
		tag if tag && tag.active?
	end

	def add_tag(tag)
		if current_tag
			tag.credit += current_tag.credit 
			current_tag.update(active: false)
		end
		tag.user = self if tag.user.nil?
		tag.active = true
		tag.save 
	end
end