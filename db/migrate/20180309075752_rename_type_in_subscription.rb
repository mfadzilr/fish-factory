class RenameTypeInSubscription < ActiveRecord::Migration[5.0]
  def change
  	rename_column :subscriptions, :type, :name
  end
end
