class CreateRecipientGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :recipient_groups do |t|
      t.string :name
      t.string :description
      t.binary :data
      t.string :filename
      t.string :mime_type

      t.timestamps
    end
  end
end
