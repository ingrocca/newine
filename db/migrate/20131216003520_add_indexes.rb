class AddIndexes < ActiveRecord::Migration
  def change
  	add_index :bottle_holders, :dispenser_id
  	add_index :dispensers, :uid
  	add_index :dispensers, :online
  	add_index :servings, :dispenser_id
  	add_index :servings, :wine_id
  	add_index :tags, :uid
  	add_index :tags, :user_id
  	add_index :temperature_controls, :dispenser_id
  	add_index :users, :name
  	add_index :users, :surname
  	add_index :users, :dni
  	add_index :users, :email
  	add_index :wines, :name
  	add_index :wines, :brand
  	add_index :wines, :vintage
  	add_index :wines, :variety
  end
end
