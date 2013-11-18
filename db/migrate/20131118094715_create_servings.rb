class CreateServings < ActiveRecord::Migration
  def change
  	create_table :servings do |t|
  		t.string :uid
  		t.integer :bottle_index
  		t.integer :serving_index
  		t.float :price
  		t.integer :volume
  		t.float :remaining_credit
  		t.integer :tag_id
  		t.integer :bottle_holder_id
  		t.integer :dispenser_id
  		t.integer :wine_id
  		t.boolean :valid_serving

  		t.timestamps
  	end
  end
end
