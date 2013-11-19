class Serving < ActiveRecord::Base
	belongs_to :wine
	belongs_to :bottle_holder
	belongs_to :tag
	belongs_to :dispenser

	validates :dispenser_id, :presence => true, :numericality => true
	validates :bottle_index, :presence => true, :numericality => true
	validates :price, :presence => :true
	validates :uid, :presence => true

	def user
		self.tag.user rescue nil
	end

end