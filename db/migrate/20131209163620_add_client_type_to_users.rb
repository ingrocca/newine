class AddClientTypeToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :client_type, :string
  end
end
