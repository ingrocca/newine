class CreateNotifications < ActiveRecord::Migration
  def change
  	create_table :notifications do |t|
  		t.text :description
  		t.string :url
  		t.boolean :read, default: false
  		t.timestamps
  	end
  end
end
