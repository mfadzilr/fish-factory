class RemoveSubscriptionIdFromUser < ActiveRecord::Migration[5.0]
  def change
  	remove_column :users, :subscription_id
  end
end
