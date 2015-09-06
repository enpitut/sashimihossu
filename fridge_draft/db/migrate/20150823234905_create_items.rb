class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.float :amount_at_once
      t.float :gram_at_once
      t.float :price_at_once
      t.float :price_at_one_amount
      t.float :price_at_one_gram
      t.text :description
      t.binary :icon

      t.timestamps null: false
    end
  end
end
