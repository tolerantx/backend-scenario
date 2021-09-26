class CreateRecipients < ActiveRecord::Migration[6.0]
  def change
    create_table :recipients do |t|
      t.string :name
      t.text :address
      t.references :school, null: false, foreign_key: true

      t.timestamps
    end
  end
end
