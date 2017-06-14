class Dispenser < ActiveRecord::Base
	has_many :bottle_holders,  -> { order(dispenser_index: :asc) }, :dependent => :destroy
	has_many :temperature_controls, :dependent => :destroy
	has_and_belongs_to_many :special_events

	validates :uid, :uniqueness => true
	#after_save :create_bottle_holders, :on => :create
	
	after_initialize :init

  def init
  	self.n_bottles ||= 8 
  end

	def to_s
		name
	end

	def create_bottle_holders
		self.n_bottles.times do |t|
			self.bottle_holders.create(:dispenser_index => t)
		end
	end

	def configure
		data = {}
		data['serving_options'] = []
		data['wine_names'] = []
		data['wine_details'] = []
		data['remaining_volumes'] = []
		self.bottle_holders.each do |bh|
			data['serving_options'][bh.dispenser_index] = {}
			data['serving_options'][bh.dispenser_index]['low'] = {:price=>bh.serving_price_low,:volume=>bh.serving_volume_low}
			data['serving_options'][bh.dispenser_index]['med'] = {:price=>bh.serving_price_med,:volume=>bh.serving_volume_med}
			data['serving_options'][bh.dispenser_index]['high'] = {:price=>bh.serving_price_high,:volume=>bh.serving_volume_high}
			data['wine_names'][bh.dispenser_index] = (bh.wine ? bh.wine.name : 'Vacio')
			data['wine_details'][bh.dispenser_index] = (bh.wine ? bh.wine.variety.to_s + ' ' + bh.wine.vintage.to_s : '')
			data['remaining_volumes'][bh.dispenser_index] = bh.remaining_volume
		end

		data['temperatures'] = []

		self.temperature_controls.each do |tc|
			data['temperatures'][tc.dispenser_index] = tc.temperature
		end

		data
	end
end
