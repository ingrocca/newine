class CreateCategory < ActiveRecord::Migration
	def change
  	create_table :categories do |t|
  		t.string :name
  		t.integer :low_percentage
  		t.integer :med_percentage
  		t.integer :high_percentage
  		t.timestamps
  	end
  end
end
