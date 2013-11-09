class Dispenser < ActiveRecord::Base
	has_many :bottle_holders

	validates :uid, :uniqueness => true
end