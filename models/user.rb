class User < ActiveRecord::Base
	validates :uid, :uniqueness => true
end