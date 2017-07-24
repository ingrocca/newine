json.(@tag, :id, :uid, :credit )
json.set!(:active, @tag.active?)
if !@tag.user.nil?
	json.user do
		json.(@tag.user, :id, :name)
	end
end
