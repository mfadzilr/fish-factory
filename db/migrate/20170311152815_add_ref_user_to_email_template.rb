class AddRefUserToEmailTemplate < ActiveRecord::Migration[5.0]
  def change
    add_reference :email_templates, :user
  end
end
