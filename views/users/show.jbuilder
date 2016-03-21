json.(@user, :id, :name, :client_type)
json.uid @tag.uid
json.credit @tag.credit

json.valid_user @user.valid_user === true
json.can_clean @user.can_clean === true
json.can_detach @user.can_detach === true
json.can_set_temp @user.can_set_temp === true



if !@user.valid?
	json.errors @user.errors.full_messages
else
	json.errors []
end