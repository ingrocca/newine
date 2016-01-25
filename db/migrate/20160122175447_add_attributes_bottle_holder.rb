class AddAttributesBottleHolder < ActiveRecord::Migration
  def change
  	add_column :bottle_holders, :actual_volume, :integer
  	add_column :bottle_holders, :bottle_status, :boolean
  	add_column :bottle_holders, :low_volume, :integer
  	add_column :bottle_holders, :mid_volume, :integer
  	add_column :bottle_holders, :high_volume, :integer
  	add_column :bottle_holders, :micro_volume, :integer
  end
end
