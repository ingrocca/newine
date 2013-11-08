json.(@user, :id, :uid, :credit, :name)
json.can_clean @user.can_clean === true
json.can_detach @user.can_detach === true
json.can_set_temp @user.can_set_temp === true

if !@user.valid?
	json.errors @user.errors.full_messages
else
	json.errors []
end