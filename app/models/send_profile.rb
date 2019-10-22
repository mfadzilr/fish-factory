class SendProfile < ApplicationRecord
	belongs_to  :user
	has_many  :campaigns

	validates :title, presence: true
	validates_inclusion_of :port, :in => 1..65534, :message => 'must be integer value in the range of 1 - 65534'
end
