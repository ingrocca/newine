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

	post '/dispensers' do
		@dispenser = Dispenser.create(params[:dispenser])
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

			return {:id => @dispenser.id}.to_json
		else
			return {:id => 0}.to_json
		end
	end

	delete '/dispensers/:id' do
		@dispenser = Dispenser.find(params[:id])
		@dispenser.destroy
		halt 204
	end

	post '/dispensers/bottle_holders/wine/:id.json' do
		data = JSON.parse(request.body.read)
		@bottle_holder = BottleHolder.find(params[:id])

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

			@bottle_holder.save
		else
			@bottle_holder.wine_id = nil
			@bottle_holder.remaining_volume = 0
			@bottle_holder.save
		end
		@dispenser = @bottle_holder.dispenser
		jbuilder :'dispensers/show'
	end
end