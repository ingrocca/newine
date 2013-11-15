class CreateEvents < ActiveRecord::Migration
  def change
  	create_table :events do |t|
  		t.string :title
  		t.text :description
  		t.string :link_url

  		t.integer :color

  		t.string :event_type

  		t.timestamps
  	end
  end
end
