class ComplementaryDrink < ActiveRecord::Base
	belongs_to :bottle_holder
	belongs_to :user
end
