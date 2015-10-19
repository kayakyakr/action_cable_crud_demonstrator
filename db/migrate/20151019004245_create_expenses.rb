class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.references :account, index: true, foreign_key: true
      t.datetime :occurred_at
      t.string :description
      t.float :amount
      t.text :comment

      t.timestamps null: false
    end
  end
end
