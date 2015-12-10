class ChangeTypeIconToItems < ActiveRecord::Migration
  def change
    change_column :items, :icon, :string
  end
end
