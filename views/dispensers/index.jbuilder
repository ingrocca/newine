json.array!(@dispensers) do |dispenser|
	json.(dispenser, :uid, :id, :name)
	json.complementary_drink "checked" if dispenser.complementary_drink
end