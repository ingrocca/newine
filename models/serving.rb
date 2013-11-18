class Serving < ActiveRecord::Base
	belongs_to :wine
	belongs_to :bottle_holder
	belongs_to :tag
	belongs_to :dispenser

	def user
		self.tag.user
	end
	def dispenser
		self.bottle_holder.dispenser
	end
end