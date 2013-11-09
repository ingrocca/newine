class CreateWines < ActiveRecord::Migration
  def change
  	create_table :wines do |t|
  		t.string :name
  		t.string :brand
  		t.text :tasting_notes
  		t.text :description
  		t.string :brief
  		t.float :bottle_cost
  		t.integer :vintage
  		

  		t.timestamps
  		# TODO add more columns...
  	end
  end
end
