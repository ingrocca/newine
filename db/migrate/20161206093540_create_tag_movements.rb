class CreateTagMovements < ActiveRecord::Migration
  def change
  	create_table :tag_movements do |t|
  		t.float :credit
  		t.integer :tag_id
  		t.timestamps
  	end
  end
end