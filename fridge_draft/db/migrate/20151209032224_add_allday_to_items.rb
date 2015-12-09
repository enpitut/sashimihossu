class AddAlldayToItems < ActiveRecord::Migration
  def change
    add_column :items, :allDay, :boolean
  end
end
