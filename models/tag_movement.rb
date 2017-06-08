class TagMovement < ActiveRecord::Base
	belongs_to :tag
	validates :tag, :presence => true
	validates :credit, :presence => true
end
