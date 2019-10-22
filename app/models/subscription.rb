class Subscription < ApplicationRecord

	belongs_to  :user, optional: true, foreign_key: :user_id
	# validates_presence_of :user
end
