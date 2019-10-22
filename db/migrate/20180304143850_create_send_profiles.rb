class CreateSendProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :send_profiles do |t|
      t.string :address
      t.integer :port
      t.string :domain
      t.string :user_name
      t.string :password
      t.string :authentication
      t.boolean :enable_starttls_auto
      t.boolean :openssl_verify_mode
      t.boolean :public
      t.integer :user_id

      t.timestamps
    end
  end
end
