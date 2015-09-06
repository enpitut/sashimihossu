class RenameColumnToItems < ActiveRecord::Migration
  def change
    rename_column :items, :gram_at_once, :gram_at_a_time
    rename_column :items, :price_at_once, :price_at_a_time
  end
end
