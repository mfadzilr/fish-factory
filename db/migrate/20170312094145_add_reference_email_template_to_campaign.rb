class AddReferenceEmailTemplateToCampaign < ActiveRecord::Migration[5.0]
  def change
    add_reference :campaigns, :email_template
  end
end
