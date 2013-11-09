class Wine < ActiveRecord::Base
	has_many :bottle_holders
end