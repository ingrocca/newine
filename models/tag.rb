class Tag < ActiveRecord::Base
	validates :uid, :uniqueness => true
	belongs_to :user
end