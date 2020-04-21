class CreateBases < ActiveRecord::Migration[5.1]
  def change
    create_table :bases do |t|
      t.string :base_name
      t.string :base_type
      t.integer :base_number
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
