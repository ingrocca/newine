class RemoveBodegaWine < ActiveRecord::Migration
  def change
  	remove_index :wines, :brand
    remove_column :wines, :brand
  end
end
