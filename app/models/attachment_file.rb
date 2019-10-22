class AttachmentFile < ApplicationRecord
  has_attached_file :payload
  # allowed_content_type = ['text/plain',
  # 'text/rtf',
  # 'text/richtext',
  # 'application/txt',
  # 'application/x-ms-dosexec',
  # 'application/octet-stream']
  # validates_attachment_content_type :payload, :content_type => allowed_content_type, :message=> "Only #{allowed_content_type} is allowed"
  do_not_validate_attachment_file_type :payload
end
