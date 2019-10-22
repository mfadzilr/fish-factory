class Report < ApplicationRecord
  belongs_to  :user
  has_many  :report_sources, dependent: :destroy
  has_many  :campaigns, through: :report_sources

  # accepts_nested_attributes_for :report_sources
  validates :title, presence: { message: "Please specify report title" } , case_sensitive: false
  validates :campaign_ids, presence: { message: "Please select atleast one campaign" }

end
