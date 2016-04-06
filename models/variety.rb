class Variety < ActiveRecord::Base
	has_many :wines

	validates :name, :presence=>true

	def to_s
		name
	end
end