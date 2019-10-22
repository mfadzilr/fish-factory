class AddSendProfileIdToCampaign < ActiveRecord::Migration[5.0]
  def change
    add_column :campaigns, :send_profile_id, :integer
  end
end
