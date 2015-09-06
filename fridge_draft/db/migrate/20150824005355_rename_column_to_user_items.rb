class RenameColumnToUserItems < ActiveRecord::Migration
  def change
    rename_column :user_items, :remain_amount, :remaining_amount
    rename_column :user_items, :remain_gram, :remaining_gram
  end
end
