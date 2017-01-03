class AddMembershipNumber < ActiveRecord::Migration
  def change
  	add_column :users, :membership_number, :integer
  end
end
