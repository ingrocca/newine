class BottleHolder < ActiveRecord::Base
	belongs_to :wine
	belongs_to :dispenser
  has_and_belongs_to_many :special_events
	has_many :complementary_drinks

  after_initialize :init
  before_create :set_last_clean_day

  def init
    self.serving_volume_low ||= wine.try(:serving_volume_low) 
    self.serving_volume_med ||= wine.try(:serving_volume_med)
    self.serving_volume_high ||= wine.try(:serving_volume_high)
    self.serving_volume_micro ||= 25
  end

  def taste
    self.remaining_volume -= 20
    self.save
  end

  def has_special_events
    !special_events.where(active: true).empty?
  end

  def discounts_special_events
    special_events.where(active: true).map(&:calculate_percentage).inject(0, &:+)
  end

  def last_clean
    begin
      (Date.today - last_day_cleaned).to_i
    rescue
      0
    end
  end

  def open_days
    begin
      (Date.today - date_bottle_change).to_i
    rescue
      0
    end
  end

  def check_bottle_status
    self.open_days >= wine.open_days
  end

  def check_bottle_cleaned
    self.last_clean >= 7
  end

  def can_complementary_drink(user)
    if dispenser.complementary_drink
      complementary_drinks.where("created_at >= ?", Time.now.beginning_of_day).where(user_id: user.id).empty?
    else
      false
    end
  end

  private
  def set_last_clean_day
    self.last_day_cleaned = Time.now
  end
end
