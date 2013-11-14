class AddValidUserToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :valid_user, :boolean
  end
end
