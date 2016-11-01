class AddBrandIdWine < ActiveRecord::Migration
def change
  	add_column :wines, :brand_id, :integer
  end
end
