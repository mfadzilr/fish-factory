class AddRefToRecipientDetails < ActiveRecord::Migration[5.0]
  def change
    add_reference :recipient_details, :recipient
    add_reference :recipient_details, :campaign
    add_reference :recipient_details, :response
  end
end
