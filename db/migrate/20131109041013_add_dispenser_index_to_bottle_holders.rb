class AddDispenserIndexToBottleHolders < ActiveRecord::Migration
  def change
  	add_column :bottle_holders, :dispenser_index, :integer
  end
end
