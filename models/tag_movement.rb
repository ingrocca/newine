class TagMovement < ActiveRecord::Base
	belongs_to :tag
	validates :tag, :presence => true
	validates :credit, :presence => true, :numericality => { :greater_than_or_equal_to => 0 }
end