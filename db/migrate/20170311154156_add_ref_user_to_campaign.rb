class AddRefUserToCampaign < ActiveRecord::Migration[5.0]
  def change
    add_reference :campaigns, :user
  end
end
