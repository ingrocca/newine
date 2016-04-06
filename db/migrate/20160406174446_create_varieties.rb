class CreateVarieties < ActiveRecord::Migration
  def change
  	create_table :varieties do |t|
  		t.text :name
  		t.timestamps
  	end
  	add_column :wines, :variety_id, :integer
  	remove_column :wines, :variety
  end
end

