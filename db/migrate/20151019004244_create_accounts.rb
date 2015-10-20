class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.references :user, index: true, foreign_key: true
      t.string :name

      t.integer :version, default: 0

      t.timestamps null: false
    end
  end
end
