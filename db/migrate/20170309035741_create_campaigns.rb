class CreateCampaigns < ActiveRecord::Migration[5.0]
  def change
    create_table :campaigns do |t|
      t.string    :title
      t.text      :description
      t.text      :sender_name
      t.text      :sender_email
      t.text      :sender_subject
      t.boolean   :attach_file, default: false
      t.datetime  :date_start_at
      t.datetime  :date_end_at
      t.timestamps
    end
  end
end
