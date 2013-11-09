class CreateBottleHolders < ActiveRecord::Migration
  def change
  	create_table :bottle_holders do |t|
  		t.integer :dispenser_id
  		t.integer :wine_id

  		t.integer :serving_volume_low
  		t.integer :serving_volume_med
  		t.integer :serving_volume_high

  		t.float :serving_price_low
  		t.float :serving_price_med
  		t.float :serving_price_high

  		t.timestamps
  		
  	end
  end
end
