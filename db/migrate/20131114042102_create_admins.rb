class CreateAdmins < ActiveRecord::Migration
  def change
  	create_table "admins" do |t|
	    t.string   "username"
	    t.string   "hashed_password"
	    t.string   "salt"
	    t.string   "email"
	    t.datetime "created_at",      :null => false
	    t.datetime "updated_at",      :null => false
	    t.boolean  "is_super_admin"
	  end
  end
end
