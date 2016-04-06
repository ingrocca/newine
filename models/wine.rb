class Wine < ActiveRecord::Base
	has_many :bottle_holders
	belongs_to :variety

	validates :name, :presence=>true
	validates :vintage, :presence=>true
	validates :variety, :presence=>true
	validates :volume, :presence=>true, :numericality=>true
	validates :open_days, :presence=>true, :numericality=>true

	after_initialize :init

  def init
    self.vintage ||= Date.today.year
    self.volume ||= 750 
    self.open_days ||= 21 
    self.serving_volume_low ||= 35 
    self.serving_volume_med ||= 70
    self.serving_volume_high ||= 140
  end
end