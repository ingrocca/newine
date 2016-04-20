class NewineServer < Sinatra::Application
	post '/bottle_holder/:id/taste' do |id|
		@bottle_holder = BottleHolder.find(id)
		@bottle_holder.taste
		{ status: 200, id: @bottle_holder.id }.to_json
	end

	post '/bottle_holder/:id/reload' do |id|
		@bottle_holder = BottleHolder.find(id)
		@bottle_holder.update(remaining_volume: @bottle_holder.wine.volume)
		{ status: 200, id: @bottle_holder.id }.to_json
	end
end