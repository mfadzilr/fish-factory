class AddSiteAddressToCampaign < ActiveRecord::Migration[5.0]
  def change
    add_column :campaigns, :site_address, :string
  end
end
