json.(@dispenser, :id, :uid)

json.bottle_holders do
	json.array!(@dispenser.bottle_holders) do |bh|
		json.(bh,:id, :serving_volume_low, :serving_volume_med, :serving_volume_high,
		 :serving_price_low, :serving_price_med, :serving_price_high, :discounts, :last_clean, :open_days)
		json.dispenser_index bh.dispenser_index + 1
		if bh.wine
			json.wine do
				json.(bh.wine,:name, :id, :variety, :vintage, :tasting_notes, :bottle_price)
				
			end
			json.volume_percent (bh.remaining_volume.to_f / bh.wine.volume) * 100
			json.remaining_volume bh.remaining_volume
		else
			json.wine nil
			json.volume_percent 0
			json.remaining_volume 0
		end
	end
	
end
json.temperature_controls do
	json.array!(@dispenser.temperature_controls.reverse) do |tc|
		json.(tc, :id, :temperature)
		json.dispenser_index tc.dispenser_index+1
	end
end
