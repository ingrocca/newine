class DispenserComplementaryDrink < ActiveRecord::Migration
	def change
  	add_column :dispensers, :complementary_drink, :boolean, default: false
  end
end
