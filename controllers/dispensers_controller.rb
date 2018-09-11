#coding: utf-8
class NewineServer < Sinatra::Application

	get  '/dispensers.json' do
		@dispensers = Dispenser.all
		jbuilder :"dispensers/index"
	end

	get '/dispensers/uid/:uid.?:format?' do
		@dispenser = Dispenser.where(:uid => params[:uid]).first
		if @dispenser.nil?
			raise Sinatra::NotFound
		end
		format_render params[:format], :"dispensers/show"
	end

	get '/dispensers/id/:id.?:format?' do
		@dispenser = Dispenser.where(:id => params[:id]).first
		if @dispenser.nil?
			raise Sinatra::NotFound
		end
		format_render params[:format], :"dispensers/show"
	end

	post '/dispensers/id/:id/update' do
		@dispenser = Dispenser.where(:id => params[:id]).first
		@dispenser.update(params['dispenser'])
		redirect "/dispensers/id/#{@dispenser.id}"
	end

	post '/dispensers' do
		@dispenser = Dispenser.create(params[:dispenser].merge(uid: SecureRandom.hex(8)))
		p 'created dispenser'
		if @dispenser.valid?
			@dispenser.create_bottle_holders
			Event.log(
				"Nuevo Dispenser",
				"ID: " + @dispenser.id.to_s + ", Nro. de Serie: " + @dispenser.uid.to_s + ".",
				"/dispensers/id/" + @dispenser.id.to_s,
				0x009933,
				"new_dispenser")
			redirect to('/dispensers/id/' + @dispenser.id.to_s)
		else
			erb :index
		end
	end

	post '/dispensers/register.json' do
		data = JSON.parse(request.body.read)
		@dispenser = Dispenser.where(:uid => data["uid"]).first
		if @dispenser
			the_time = Time.now
			@dispenser.ip = request.ip
			@dispenser.last_registration = the_time
			@dispenser.last_activity = the_time
			@dispenser.online = true
			@dispenser.save
			$channel.push({:dispenser=>{:id=> @dispenser.id,:online=>true}}.to_json)
			return {:id => @dispenser.id}.to_json
		else
			p "Unknown uid: " + data["uid"]
			return {:id => 0}.to_json
		end
	end

	post '/dispensers/ping.json' do
		data = JSON.parse(request.body.read)
		@dispenser = Dispenser.find(data["id"]) rescue nil
		if @dispenser
			the_time = Time.now
			@dispenser.ip = request.ip
			@dispenser.last_activity = the_time
			@dispenser.online = true
			@dispenser.save

			return ""
		else
			halt 404
		end
	end

	delete '/dispensers/:id' do
		@dispenser = Dispenser.find(params[:id])
		@dispenser.destroy
		halt 204
	end

	post '/dispensers/bottle_holders/wine/:id.json' do
		data = JSON.parse(request.body.read)
		p data
		begin
			@bottle_holder = BottleHolder.find(params[:id])
		rescue
			@bottle_holder = BottleHolder.where(dispenser_id: data['dispenser_id'], dispenser_index: data['dispenser_index']).last
		end
		
		if data['wine_id']
			@wine = Wine.find(data['wine_id'])

			@bottle_holder.wine_id = @wine.id

			@bottle_holder.remaining_volume = @wine.volume

			@bottle_holder.serving_volume_low = @wine.serving_volume_low
			@bottle_holder.serving_price_low = @wine.serving_price_low

			@bottle_holder.serving_volume_med = @wine.serving_volume_med
			@bottle_holder.serving_price_med = @wine.serving_price_med

			@bottle_holder.serving_volume_high = @wine.serving_volume_high
			@bottle_holder.serving_price_high = @wine.serving_price_high
			now = Time.now
			@bottle_holder.date_bottle_change = now
			@bottle_holder.last_day_cleaned = now if @bottle_holder.last_day_cleaned.nil?

			@bottle_holder.save
			Event.log(
			"Cambio de botella",
			"Se coloco el vino #{@bottle_holder.wine} en el dispenser #{@bottle_holder.dispenser.name} en la posición #{@bottle_holder.dispenser_index}",
			"#",
			0xffffff,
			"change_bottle")
		else
			@bottle_holder.wine_id = nil
			@bottle_holder.remaining_volume = 0
			@bottle_holder.save
		end
		@dispenser = @bottle_holder.dispenser
		@dispenser.configure
		jbuilder :'dispensers/show'
	end

	post '/dispensers/bottle_holders/servings/:id.json' do
		
		@bottle_holder = BottleHolder.find(params[:id])

		@bottle_holder.serving_volume_low = params['serving_volume_low']
		@bottle_holder.serving_price_low = params['serving_price_low']

		@bottle_holder.serving_volume_med = params['serving_volume_med']
		@bottle_holder.serving_price_med = params['serving_price_med']

		@bottle_holder.serving_volume_high = params['serving_volume_high']
		@bottle_holder.serving_price_high = params['serving_price_high']
		if @bottle_holder.remaining_volume != params['remaining_volume']
		Event.log(
			"Cambio de volumen",
			"Se cambio el volumen del vino #{@bottle_holder.wine} en el dispenser #{@bottle_holder.dispenser.name} en la posición #{@bottle_holder.dispenser_index}. Volumen: #{@bottle_holder.remaining_volume} - Nuevo Volumen: #{params['remaining_volume']}.",
			"#",
			0xffffff,
			"change_bottle")			
		end
		@bottle_holder.remaining_volume = params['remaining_volume']
		@bottle_holder.discounts = params['discounts']
		@bottle_holder.save
		
		@dispenser = @bottle_holder.dispenser
		@dispenser.configure
		jbuilder :'dispensers/show'
	end

	post '/dispensers/temperature/:id.json' do
		@temperature_control = TemperatureControl.find(params[:id])
		@temperature_control.temperature = params[:temperature]

		@temperature_control.save

		@dispenser = @temperature_control.dispenser
		
		@dispenser.configure

		jbuilder :'dispensers/show'
	end

	post '/dispensers/temperature.json' do
		data = JSON.parse(request.body.read)
		@temperature_control = Dispenser.find(data['dispenser_id']).temperature_controls
			.where(:dispenser_index => data['dispenser_index']).first

		@temperature_control.temperature = data['temperature']
		@temperature_control.save

		Event.log(
			"Temperatura Actualizada",
			"Dispenser: " + @temperature_control.dispenser.uid + ", Botella: " + (@temperature_control.dispenser_index+1).to_s +
				", T=" + @temperature_control.temperature.to_s + "ºC",
			"/dispensers/id/" + @temperature_control.dispenser_id.to_s,
			0xEEEEEE,
			"temperature_change")
		$channel.push({:temperature_control => @temperature_control}.to_json)

		"TEMP OK"
	end

	post '/dispensers/:id/destroy' do |id|
		@dispenser = Dispenser.find(id)
		@dispenser.destroy
		{ status: 200 }.to_json
	end

	post '/dispensers/:id/update' do |id|
		@dispenser = Dispenser.find(id)
		@dispenser.update_attributes(params[:dispenser])
		{ status: 200 }.to_json
	end
end
