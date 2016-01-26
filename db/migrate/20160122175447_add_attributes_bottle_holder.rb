class AddAttributesBottleHolder < ActiveRecord::Migration
  def change
  	add_column :bottle_holders, :actual_volume, :integer
  	add_column :bottle_holders, :bottle_status, :boolean
  	add_column :bottle_holders, :serving_volume_micro, :integer
  end
end
