class CreateTags < ActiveRecord::Migration
  def change
  	create_table :tags do |t|
  		t.string :uid
  		t.float :credit
  		t.integer :user_id
  	end
  end
end
