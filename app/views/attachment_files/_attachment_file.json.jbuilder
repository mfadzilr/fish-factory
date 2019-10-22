json.extract! attachment_file, :id, :name, :description, :created_at, :updated_at
json.url attachment_file_url(attachment_file, format: :json)
