json.(@dispenser, :id, :uid)

json.bottle_holders do
	json.array!(@dispenser.bottle_holders) do |bh|
		json.(bh,:id)
		json.dispenser_index bh.dispenser_index + 1
		if bh.wine
			json.wine do
				json.(bh.wine,:name)
			end
			json.volume_percent (bh.remaining_volume.to_f / bh.wine.volume) * 100
		else
			json.wine nil
		end
	end
end