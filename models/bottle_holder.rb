class BottleHolder < ActiveRecord::Base
	belongs_to :wine
	belongs_to :dispenser
	has_and_belongs_to_many :special_events

	after_initialize :init

  def init
    self.serving_volume_low ||= wine.try(:serving_volume_low) 
    self.serving_volume_med ||= wine.try(:serving_volume_med)
    self.serving_volume_high ||= wine.try(:serving_volume_high)
    self.serving_volume_micro ||= 25
  end
end