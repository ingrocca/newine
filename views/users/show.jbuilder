json.(@user, :id, :uid, :credit, :name)
if !@user.valid?
	json.errors @user.errors.full_messages
end