class AddUseridStartEndRemainingamountRemaininggramToItems < ActiveRecord::Migration
  def change
    add_column :items, :user_id, :integer
    add_column :items, :start, :datetime
    add_column :items, :end, :datetime
    add_column :items, :remaining_amount, :float
    add_column :items, :remaining_gram, :float
  end
end
