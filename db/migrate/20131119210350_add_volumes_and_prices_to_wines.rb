class AddVolumesAndPricesToWines < ActiveRecord::Migration
  def change
  	change_table :wines do |t|
  		t.integer :serving_volume_low
  		t.integer :serving_volume_med
  		t.integer :serving_volume_high

  		t.float :serving_price_low
  		t.float :serving_price_med
  		t.float :serving_price_high
  	end
  end
end
