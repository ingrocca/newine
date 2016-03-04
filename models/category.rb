class Category < ActiveRecord::Base
	has_many :users

	validates :low_percentage, inclusion: { in: 1..100 }
	validates :med_percentage, inclusion: { in: 1..100 }
	validates :high_percentage, inclusion: { in: 1..100 }

	def to_s
		name
	end
end