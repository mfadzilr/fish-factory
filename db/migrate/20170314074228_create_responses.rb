class CreateResponses < ActiveRecord::Migration[5.0]
  def change
    create_table :responses do |t|

      t.string    :token
      t.datetime  :expired_at
      t.boolean   :status, default: false
      t.string    :error_message
      t.timestamps
    end
  end
end
