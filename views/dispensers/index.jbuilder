json.array!(@dispensers) do |dispenser|
	json.(dispenser, :uid, :id, :name)
end