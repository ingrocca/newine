class TagMovement < ActiveRecord::Base
  belongs_to :tag
	belongs_to :user
  validates :user, :presence => true
	validates :tag, :presence => true
	validates :credit, :presence => true
end
