class Wine < ActiveRecord::Base
	has_many :bottle_holders
	belongs_to :variety
	belongs_to :brand

	validates :name, :presence=>true
	validates :vintage, :presence=>true
	validates :variety, :presence=>true
	validates :volume, :presence=>true, :numericality => { :greater_than_or_equal_to => 0 }
	validates :open_days, :presence=>true, :numericality => { :greater_than_or_equal_to => 0 }
	validates :serving_volume_low, :presence=>true, :numericality => { :greater_than_or_equal_to => 0 }
	validates :serving_volume_med, :presence=>true, :numericality => { :greater_than_or_equal_to => 0 }
	validates :serving_volume_high, :presence=>true, :numericality => { :greater_than_or_equal_to => 0 }
	validates :serving_price_low, :presence=>true, :numericality => { :greater_than_or_equal_to => 0 }
	validates :serving_price_med, :presence=>true, :numericality => { :greater_than_or_equal_to => 0 }
	validates :serving_price_high, :presence=>true, :numericality => { :greater_than_or_equal_to => 0 }

	after_initialize :init

	def to_s
		"#{name} - #{variety} - #{vintage}"
	end

  def init
    self.vintage ||= Date.today.year
    self.volume ||= 750 
    self.open_days ||= 21 
    self.serving_volume_low ||= 35 
    self.serving_volume_med ||= 70
    self.serving_volume_high ||= 140
    self.serving_price_low ||= 0
    self.serving_price_med ||= 0
    self.serving_price_high ||= 0
    self.bottle_cost ||= 0
    self.bottle_price ||= 0
  end

  def volume_cost
  	self.bottle_cost / self.volume
  end
end
