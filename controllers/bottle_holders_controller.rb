class NewineServer < Sinatra::Application
	post '/bottle_holder/find_or_create' do
		@bottle_holder = BottleHolder.find_or_create_by(wine_id: params['wine_id'], dispenser_id: params['dispenser_id'], dispenser_index: params[:dispenser_index])
		@bottle_holder.update( serving_volume_low: params['serving_volume_low'], serving_volume_med: params['serving_volume_med'], serving_volume_high: params['serving_volume_high'], serving_volume_micro: params['serving_volume_micro'] )
		{ status: 200, id: @bottle_holder.id }.to_json
	end
end