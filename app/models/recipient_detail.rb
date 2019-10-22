class RecipientDetail < ApplicationRecord
  belongs_to  :response
  belongs_to  :recipient
  belongs_to  :campaign
end
