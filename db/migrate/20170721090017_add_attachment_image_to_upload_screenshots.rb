class AddAttachmentImageToUploadScreenshots < ActiveRecord::Migration
  def self.up
    change_table :upload_screenshots do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :upload_screenshots, :image
  end
end
