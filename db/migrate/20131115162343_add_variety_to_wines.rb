class AddVarietyToWines < ActiveRecord::Migration
  def change
  	add_column :wines, :variety, :string
  end
end
