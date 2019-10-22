class Notification < ApplicationRecord
	belongs_to  :user, foreign_key: :user_id
	#default_scope { order(created_at: :desc), limit(10) }
end
