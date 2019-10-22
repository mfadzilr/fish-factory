json.extract! notification, :id, :note, :read, :user_id, :created_at, :updated_at
json.url notification_url(notification, format: :json)
