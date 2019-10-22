class ReportSource < ApplicationRecord
  belongs_to :report
  belongs_to :campaign
end
