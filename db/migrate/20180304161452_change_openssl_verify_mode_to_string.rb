class ChangeOpensslVerifyModeToString < ActiveRecord::Migration[5.0]
  def change
  	change_column :send_profiles, :openssl_verify_mode, :string
  end
end
