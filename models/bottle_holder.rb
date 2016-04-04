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

  def remaining_volume 
    read_attribute(:remaining_volume) - 20 rescue 0 
  end

  def has_special_events
    !special_events.where(active: true).empty?
  end

  def discounts_special_events
    special_events.where(active: true).map(&:calculate_percentage).inject(0, &:+)
  end

  def check_bottle_status
    begin
      (Date.today - date_bottle_change).to_i >= wine.open_days
    rescue
      false
    end
  end

  def check_bottle_cleaned
    begin
      (Date.today - last_day_cleaned).to_i >= 7
    rescue 
      false
    end
  end
end