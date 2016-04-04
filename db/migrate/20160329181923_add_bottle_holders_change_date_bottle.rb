class AddBottleHoldersChangeDateBottle < ActiveRecord::Migration
 def change
    add_column :bottle_holders, :date_bottle_change, :date
    add_column :bottle_holders, :last_day_cleaned, :date
  end
end
