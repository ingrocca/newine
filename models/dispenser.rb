class Dispenser < ActiveRecord::Base
	has_many :bottle_holders, :dependent => :destroy

	validates :uid, :uniqueness => true
	after_save :create_bottle_holders, :on => :create

	def create_bottle_holders
		self.n_bottles.times do |t|
			self.bottle_holders.create(:dispenser_index => t)
		end
	end
end