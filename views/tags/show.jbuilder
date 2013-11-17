json.(@tag, :id, :uid, :credit)

if !@tag.user.nil?
	json.user do
		json.(@tag.user, :id, :name)
	end
end