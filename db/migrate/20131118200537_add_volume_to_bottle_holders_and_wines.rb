class AddVolumeToBottleHoldersAndWines < ActiveRecord::Migration
  def change
  	add_column :wines, :volume, :integer
  	add_column :bottle_holders, :remaining_volume, :integer
  end
end
