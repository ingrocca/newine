json.array!(@events) do |event|
	json.(event, :id, :title, :description, :color, :event_type, :created_at, :link_url)
end