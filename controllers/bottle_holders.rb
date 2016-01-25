class NewineServer < Sinatra::Application
	post '/bottle_holder' do 
		@bottle_holder = BottleHolder.find_or_create_by(wine_id: params['wine_id'], dispenser_id: params['dispenser_id'])
	end
end