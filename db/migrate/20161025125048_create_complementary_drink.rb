class CreateComplementaryDrink < ActiveRecord::Migration
	def change
  	create_table :complementary_drinks do |t|
  		t.integer :user_id
  		t.integer :bottle_holder_id
  		t.timestamps
  	end
  end
end

