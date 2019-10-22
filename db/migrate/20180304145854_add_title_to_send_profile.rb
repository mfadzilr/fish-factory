class AddTitleToSendProfile < ActiveRecord::Migration[5.0]
  def change
    add_column :send_profiles, :title, :string
  end
end
