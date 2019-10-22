class Recipient < ApplicationRecord
  belongs_to              :recipient_group
  has_many                :responses
  has_many                :recipient_details

  validates :full_name, case_sensitive: false
  validates :full_name, presence: true
  validates :email_to, presence: true
  validates_uniqueness_of :email_to, scope: :recipient_group_id, uniqueness: { case_sensitive: false }
  validates_format_of     :email_to, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  before_save { self.email_to = email_to.downcase }
end
