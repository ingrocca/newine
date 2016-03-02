class RemoveDispenserIdBottleHolderId < ActiveRecord::Migration
  def change
    remove_column :special_events, :dispenser_id
    remove_column :special_events, :bottle_holder_id
  end
end
