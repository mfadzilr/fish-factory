class CreateCampaignSources < ActiveRecord::Migration[5.0]
  def change
    create_table :campaign_sources do |t|
      t.belongs_to :campaign, index: true
      t.belongs_to :recipient_group, index: true
      t.timestamps
    end
  end
end
