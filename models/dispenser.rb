class Dispenser < ActiveRecord::Base
	has_many :bottle_holders, :dependent => :destroy
	has_many :temperature_controls, :dependent => :destroy

	validates :uid, :uniqueness => true
	#after_save :create_bottle_holders, :on => :create

	def create_bottle_holders
		self.n_bottles.times do |t|
			self.bottle_holders.create(:dispenser_index => t)
		end
	end
	def create_temperature_controls
		self.n_temperature_controls.times do |t|
			self.temperature_controls.create(:dispenser_index => t, :temperature => 18)
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
			data['wine_details'][bh.dispenser_index] = (bh.wine ? bh.wine.variety + ' ' + bh.wine.vintage.to_s : '')
			data['remaining_volumes'][bh.dispenser_index] = bh.remaining_volume
		end


		data['temperatures'] = []

		self.temperature_controls.each do |tc|
			data['temperatures'][tc.dispenser_index] = tc.temperature
		end

		p data.to_json
		RestClient.post(self.ip + ':3001',data.to_json + "\n",:content_type => :json, :accept => :json)
	end
	def shutdown
		RestClient.post(self.ip + ':3001',"SHUTDOWN" + "\n",:content_type => :json, :accept => :json)
		self.online = false
		self.save
		$channel.push({:dispenser=>{:id=> self.id,:online=>false}}.to_json)
	end
end