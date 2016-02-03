class CreateSpecialEvents < ActiveRecord::Migration
  def change
  	create_table :special_events do |t|
  		t.string :type
  		t.string :name
  		t.integer :percentage
  		t.belongs_to :disperser, index: true
  		t.belongs_to :bottle_holder, index: true
  		t.timestamps
  	end
  end
end
