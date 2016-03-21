class AddActiveSpecialEvents < ActiveRecord::Migration
  def change
    add_column :special_events, :active, :boolean, default: true
  end
end
