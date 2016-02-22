class Category < ActiveRecord::Base
	validates :low_percentage, inclusion: { in: 1..100 }
	validates :med_percentage, inclusion: { in: 1..100 }
	validates :high_percentage, inclusion: { in: 1..100 }
end