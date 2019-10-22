class CreateSitePages < ActiveRecord::Migration[5.0]
  def change
    create_table :site_pages do |t|
      t.string :title
      t.text :description
      t.text :content
      t.boolean :is_private, default: true

      t.timestamps
    end
  end
end
