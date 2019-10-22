class CreateRecipientDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :recipient_details do |t|
      t.integer   :request_type # 1 = open_image, 2 = open_url
      t.string    :ip_address
      t.string    :user_agent
      t.text      :data
      t.timestamps
    end
  end
end
