json.(@dispenser, :id, :uid)

json.bottle_holders do
	json.array!(@dispenser.bottle_holders) do |bh|
		json.(bh,:id, :serving_volume_low, :serving_volume_med, :serving_volume_high,
		 :serving_price_low, :serving_price_med, :serving_price_high)
		json.dispenser_index bh.dispenser_index + 1
		if bh.wine
			json.wine do
				json.(bh.wine,:name, :id, :variety, :vintage)
			end
			json.volume_percent (bh.remaining_volume.to_f / bh.wine.volume) * 100
		else
			json.wine nil
		end
	end
end