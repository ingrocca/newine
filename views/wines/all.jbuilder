json.array!(@wines) do |wine|
	json.( wine, :id, :name )
end