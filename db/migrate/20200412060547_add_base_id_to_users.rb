class AddBaseIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :base_id, :integer
  end
end
