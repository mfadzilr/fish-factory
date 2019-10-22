class CampaignSource < ApplicationRecord
  belongs_to  :campaign
  belongs_to  :recipient_group
end
