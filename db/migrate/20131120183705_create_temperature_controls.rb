class CreateTemperatureControls < ActiveRecord::Migration
  def change
  	create_table :temperature_controls do |t|
  		t.integer :dispenser_index
  		t.integer :temperature
  		t.integer :dispenser_id
  		t.timestamps
  	end
  	add_column :dispensers, :n_temperature_controls, :integer
  end
end
