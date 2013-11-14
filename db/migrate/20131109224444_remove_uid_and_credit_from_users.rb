class RemoveUidAndCreditFromUsers < ActiveRecord::Migration
  def change
  	remove_column :users, :credit
  	remove_column :users, :uid
  end
end
