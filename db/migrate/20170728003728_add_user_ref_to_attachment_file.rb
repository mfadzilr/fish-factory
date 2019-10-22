class AddUserRefToAttachmentFile < ActiveRecord::Migration[5.0]
  def change
    add_reference :attachment_files, :user
  end
end
