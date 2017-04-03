class RenameAdminAttr < ActiveRecord::Migration
  def change
    remove_column :admins, :hashed_password
    remove_column :admins, :salt
    remove_column :admins, :is_super_admin
    add_column :admins, :crypted_password, :string
  end
end
