class Brand < ActiveRecord::Base
	has_many :wines

	validates :name, :presence=>true

	before_create :titleize_name
	def to_s
		name
	end

	private
	def titleize_name
		self.name = self.name.titleize
	end
end