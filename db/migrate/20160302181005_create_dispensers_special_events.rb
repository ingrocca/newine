class CreateDispensersSpecialEvents < ActiveRecord::Migration
  def change
  	create_table :dispensers_special_events do |t|
  		t.belongs_to :dispenser, index: true
  		t.belongs_to :special_event, index: true
  	end
  end
end
