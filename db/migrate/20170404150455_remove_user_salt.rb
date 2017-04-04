class RemoveUserSalt < ActiveRecord::Migration
  def change
    remove_column :admins, :salt
  end
end
