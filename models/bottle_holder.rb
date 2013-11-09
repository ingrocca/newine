class BottleHolder < ActiveRecord::Base
	belongs_to :wine
	belongs_to :dispenser
end