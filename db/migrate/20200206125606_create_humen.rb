class CreateHumen < ActiveRecord::Migration[6.0]
  def change
    create_table :humen do |t|
      t.text :problem
      t.text :solution
      t.text :aim
      t.integer :expected_time
      t.integer :order
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
