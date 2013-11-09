class AddNBottleHoldersToDispensers < ActiveRecord::Migration
  def change
  	add_column :dispensers, :n_bottles, :integer
  end
end
