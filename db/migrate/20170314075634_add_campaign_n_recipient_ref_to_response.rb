class AddCampaignNRecipientRefToResponse < ActiveRecord::Migration[5.0]
  def change
    add_reference :responses, :campaign
    add_reference :responses, :recipient
  end
end
