class AddRecipientGroup < ActiveRecord::Migration[5.0]
  def change
    add_reference :recipients, :recipient_group
    add_reference :recipient_groups, :user
  end
end
