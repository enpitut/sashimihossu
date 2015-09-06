class AddNameGradePointDescriptionSexAgeAndIconToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :grade, :integer
    add_column :users, :point, :integer
    add_column :users, :description, :text
    add_column :users, :sex, :string
    add_column :users, :age, :string
    add_column :users, :icon, :binary
  end
end
