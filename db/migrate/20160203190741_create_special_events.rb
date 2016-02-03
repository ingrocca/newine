class CreateSpecialEvents < ActiveRecord::Migration
  def change
  	create_table :special_events do |t|
  		t.string :type
  		t.name :string
  		t.integer :percentage
  		t.timestamps
  	end
  end
end
