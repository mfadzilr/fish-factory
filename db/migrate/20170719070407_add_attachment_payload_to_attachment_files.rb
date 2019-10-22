class AddAttachmentPayloadToAttachmentFiles < ActiveRecord::Migration
  def self.up
    change_table :attachment_files do |t|
      t.attachment :payload
    end
  end

  def self.down
    remove_attachment :attachment_files, :payload
  end
end
