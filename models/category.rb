class Category < ActiveRecord::Base
	has_many :users

	validates :low_percentage, inclusion: { in: 0..100 }
	validates :med_percentage, inclusion: { in: 0..100 }
	validates :high_percentage, inclusion: { in: 0..100 }

	def to_s
		name
	end

	def calculate_low_percentage
		low_percentage.to_f / 100.0
	end

	def calculate_med_percentage
		med_percentage.to_f / 100.0
	end
	
	def calculate_high_percentage
		high_percentage.to_f / 100.0
	end
end
