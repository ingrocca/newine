json.array!(@wines) do |wine|
	json.(wine, :id, :name, :vintage, :variety, :tasting_notes)
end