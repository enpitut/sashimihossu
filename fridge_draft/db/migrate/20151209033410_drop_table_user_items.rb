class DropTableUserItems < ActiveRecord::Migration
  def change
    drop_table :user_items
  end
end
