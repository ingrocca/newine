class NewineServer < Sinatra::Application
	post '/bottle_holder/taste' do
		data = JSON.parse(request.body.read)
		@bottle_holder = BottleHolder.where(dispenser_id: data['dispenser_id'], dispenser_index: data['dispenser_index']).last
		@bottle_holder.taste
		@dispenser = @bottle_holder.dispenser
		Event.log(
			"Muestra",
			"Muestra de vino #{@bottle_holder.wine} en el dispenser #{@bottle_holder.dispenser.name}",
			"#",
			0xffffff,
			"taste")
		@dispenser.configure
		{ status: 200, id: @bottle_holder.id }.to_json
	end

		post '/bottle_holder/clean' do
		data = JSON.parse(request.body.read)
		@bottle_holder = BottleHolder.where(dispenser_id: data['dispenser_id'], dispenser_index: data['dispenser_index']).last
		@bottle_holder.update(last_day_cleaned: Time.now)
		Event.log(
			"Limpieza",
			"Se realizó la limpieza del dispenser #{@bottle_holder.dispenser.name} en la posición #{@bottle_holder.dispenser_index + 1}",
			"#",
			0xffffff,
			"clean")
		{ status: 200, id: @bottle_holder.id }.to_json
	end

	post '/bottle_holder/reload' do
		data = JSON.parse(request.body.read)
		@bottle_holder = BottleHolder.where(dispenser_id: data['dispenser_id'], dispenser_index: data['dispenser_index']).last
		@bottle_holder.update(remaining_volume: @bottle_holder.wine.volume, date_bottle_change: Time.now)
		@dispenser = @bottle_holder.dispenser
		Event.log(
			"Cambio de botella",
			"Se coloco el vino #{@bottle_holder.wine} en el dispenser #{@bottle_holder.dispenser.name} en la posición #{@bottle_holder.dispenser_index}",
			"#",
			0xffffff,
			"change_bottle")
		@dispenser.configure
		{ status: 200, id: @bottle_holder.id }.to_json
	end

	post '/bottle_holder/days_bottle_change' do
		data = JSON.parse(request.body.read)
		@bottle_holder = BottleHolder.where(dispenser_id: data['dispenser_id'], dispenser_index: data['dispenser_index']).last
		{ status: 200, days: @bottle_holder.open_days }.to_json
	end

end
