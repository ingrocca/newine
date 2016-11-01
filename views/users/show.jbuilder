json.(@user, :id, :name, :client_type)
json.uid @tag.uid
json.credit @tag.credit

json.valid_user @user.valid_user === true
json.can_clean @user.can_clean === true
json.can_detach @user.can_detach === true
json.can_set_temp @user.can_set_temp === true

json.category @user.category.try(:name)
json.category_low_percentage @user.category ? @user.category.low_percentage : 0
json.category_medium_percentage @user.category ? @user.category.med_percentage : 0
json.category_high_percentage @user.category ? @user.category.high_percentage : 0

json.bottle_holders do
	json.array!(@dispenser.bottle_holders) do |bh|
		json.dispenser_index bh.dispenser_index + 1
		json.can_complementary_drink bh.can_complementary_drink(@user)
	end
end

if !@user.valid?
	json.errors @user.errors.full_messages
else
	json.errors []
end