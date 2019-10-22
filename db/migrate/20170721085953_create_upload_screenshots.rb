class CreateUploadScreenshots < ActiveRecord::Migration[5.0]
  def change
    create_table :upload_screenshots do |t|
      t.string :origin

      t.timestamps
    end
  end
end
