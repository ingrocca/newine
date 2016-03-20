class AddTypeSpecialEvents < ActiveRecord::Migration
  def change
    remove_column :special_events, :type
    add_column :special_events, :type_special_event, :string
  end
end
