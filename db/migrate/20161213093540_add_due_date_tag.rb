class AddDueDateTag < ActiveRecord::Migration
  def change
  	add_column :tags, :due_date, :date
  end
end
