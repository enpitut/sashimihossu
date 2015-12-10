class CreateFreshnesses < ActiveRecord::Migration
  def change
    create_table :freshnesses do |t|
      t.string :name
      t.integer :freshness

      t.timestamps null: false
    end
  end
end
