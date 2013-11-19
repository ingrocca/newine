class AddIpToDispensers < ActiveRecord::Migration
  def change
  	add_column :dispensers, :ip, :string
  end
end
