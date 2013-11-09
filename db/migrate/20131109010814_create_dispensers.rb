class CreateDispensers < ActiveRecord::Migration
  def change
  	create_table :dispensers do |t|
  		t.string :uid
  		t.string :name
  		t.datetime :last_registration
  		t.datetime :last_activity
  		t.boolean :online
  		t.timestamps
  		# TODO add more columns...
  	end
  end
end
