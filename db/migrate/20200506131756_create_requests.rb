class CreateRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :requests do |t|
      t.date :month
      t.integer :mark
      t.integer :superior_id
      t.integer :user_id

      t.timestamps
    end
  end
end
