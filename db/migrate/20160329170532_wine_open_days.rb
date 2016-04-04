class WineOpenDays < ActiveRecord::Migration
 def change
    add_column :wines, :open_days, :integer
  end
end
