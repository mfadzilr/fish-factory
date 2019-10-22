class EmailTemplate < ApplicationRecord
  has_many    :campaigns
  belongs_to  :user

  validates   :title, presence: true
  validates   :title, uniqueness: { case_sensitive: false }, on: :create
end
