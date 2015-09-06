class RenameColumnToItems2 < ActiveRecord::Migration
  def change
    rename_column :items, :amount_at_once, :amount_at_a_time
  end
end
