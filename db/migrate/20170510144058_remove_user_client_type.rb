class RemoveUserClientType < ActiveRecord::Migration
  def change
    remove_column :users, :client_type
  end
end
