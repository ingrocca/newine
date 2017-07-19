class AddUserTagMovement < ActiveRecord::Migration
  def change
    add_column :tag_movements, :user_id, :integer
  end
end
