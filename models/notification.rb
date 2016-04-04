class Notification < ActiveRecord::Base
	validates :description, presence: true
end