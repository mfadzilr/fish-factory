class AddStatusToCampaigns < ActiveRecord::Migration[5.0]
  def change
    add_column :campaigns, :status, :integer
    add_column :campaigns, :total_target, :integer
    add_column :campaigns, :total_completed, :integer
  end
end
