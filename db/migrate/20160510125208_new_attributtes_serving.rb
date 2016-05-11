class NewAttributtesServing < ActiveRecord::Migration
 def change
    add_column :servings, :volume_cost, :float
  end
end
