class CreateShoppingManagementDevelopments < ActiveRecord::Migration
  def change
    create_table :shopping_management_developments do |t|
      t.integer :categoryCd
      t.string :goods
      t.datetime :date
      t.integer :amount
      t.integer :sum
      t.string :place

      t.timestamps
    end
  end
end
