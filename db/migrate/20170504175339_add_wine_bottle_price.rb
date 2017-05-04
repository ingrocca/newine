class AddWineBottlePrice < ActiveRecord::Migration
def change
    add_column :wines, :bottle_price, :float, default: 0
  end
end
