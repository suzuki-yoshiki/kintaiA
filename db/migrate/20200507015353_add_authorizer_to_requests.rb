class AddAuthorizerToRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :authorizer, :integer
  end
end
