class CreateBottleHoldersSpecialEvents < ActiveRecord::Migration
	def change
  	create_table :bottle_holders_special_events do |t|
  		t.belongs_to :bottle_holder, index: true
  		t.belongs_to :special_event, index: true
  	end
  end
end
