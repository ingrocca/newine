class AddTypeServings < ActiveRecord::Migration
  def change
    add_column :servings, :mode, :string, default: 'self_serving'
  end
end
