class NewineServer < Sinatra::Application
	post '/bottle_holder/:id/taste' do |id|
		@bottle_holder = BottleHolder.find(id)
		@bottle_holder.wine.taste
		{ status: 200, id: @bottle_holder.id }.to_json
	end
end