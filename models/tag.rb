class Tag < ActiveRecord::Base
	validates :uid, :uniqueness => true, :presence=>true
	belongs_to :user
end