class CreateShohis < ActiveRecord::Migration
  def change
    create_table :shohis do |t|
      t.integer :categoryCd
      t.string :goods
      t.integer :shohiSum
      t.datetime :shohiDate

      t.timestamps
    end
  end
end
