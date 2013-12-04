class AddFieldsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :surname, :string
  	add_column :users, :dni, :string
  	add_column :users, :phone, :string
  	add_column :users, :email, :string
  end
end
