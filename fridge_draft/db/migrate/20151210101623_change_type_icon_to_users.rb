class ChangeTypeIconToUsers < ActiveRecord::Migration
  def change
    change_column :users, :icon, :string
  end
end
