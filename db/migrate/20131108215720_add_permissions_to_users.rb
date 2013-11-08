class AddPermissionsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :can_clean, :boolean
  	add_column :users, :can_detach, :boolean
  	add_column :users, :can_set_temp, :boolean
  end
end
