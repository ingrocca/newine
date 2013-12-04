class AddUserIdToServings < ActiveRecord::Migration
  def change
  	add_column :servings, :user_id, :integer
  end
end
