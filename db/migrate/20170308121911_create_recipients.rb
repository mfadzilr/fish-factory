class CreateRecipients < ActiveRecord::Migration[5.0]
  def change
    create_table :recipients do |t|
      t.string :full_name
      t.string :designation
      t.string :department
      t.string :email_to
      t.timestamps
    end
  end
end
