class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.references :school, null: false, foreign_key: true
      t.integer :status, default: 1
      t.date :date
      t.boolean :notify_user

      t.timestamps
    end
  end
end
