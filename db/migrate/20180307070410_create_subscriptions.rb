class CreateSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :subscriptions do |t|
      t.string :type
      t.integer :total
      t.date :date_expired_at

      t.timestamps
    end
    add_index :subscriptions, :type
  end
end
