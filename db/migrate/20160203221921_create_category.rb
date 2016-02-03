class CreateCategory < ActiveRecord::Migration
	def change
  	create_table :categories do |t|
  		t.string :type
  		t.integer :percentage
  		t.timestamps
  	end
  end
end
