class UploadScreenshot < ApplicationRecord
    has_attached_file :image
    validates_attachment_content_type :image, content_type: /\Aimage/
    validates_attachment  :image,
      content_type: { content_type: ['image/jpeg', 'image/gif', 'image/png', 'image/bmp'] }
    # do_not_validate_attachment_file_type :image
end
