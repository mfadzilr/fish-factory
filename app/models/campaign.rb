class Campaign < ApplicationRecord
  # before_save :init, on: [:create ]
  # before_update :calculate_target
 
  belongs_to  :user
  has_one     :email_template
  has_one     :attachment_file
  has_one     :send_profile
  has_many    :responses, dependent: :destroy
  has_many    :campaign_sources, dependent: :destroy
  has_many    :recipient_groups, through: :campaign_sources
  has_many    :recipients, through: :recipient_groups
  has_many    :recipient_details
  has_many    :site_pages
  has_many    :report_sources, dependent: :destroy
  has_many    :reports, through: :report_sources

  validates :date_end_at, presence: { message: "Please specify Date End" }
  validates :date_start_at, presence: { message: "Please specify Date Start" }
  validates :date_start_at, :date => {:message => 'Date Start must be within 1 month from today.', :after => Proc.new { Time.now - 1.months }, :before => Proc.new { Time.now + 1.month } }
  validates :date_end_at, date: { after: :date_start_at, message: "Date End must be after Date Start"}
  validates :title, presence: { message: "Please specify campaign title" } , case_sensitive: false
  validates :sender_name, presence: { message: "Please specify sender name" }
  validates :sender_subject, presence: { message: "Please specify subject" }
  validates :send_profile_id, presence: { message: "Please select a send profile" }
  validates :email_template_id, presence: { message: "Please select phishing email template" }
  validates :site_page_id, presence: { message: "Please select phishing site" }
  validates :recipient_group_ids, presence: { message: "Please select atleast one target group" }
  validates_uniqueness_of :title, scope: :user_id, message: "Title already exists" 
 
  validates_format_of :sender_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, message: "Email is invalid"  

  before_save { self.sender_email = sender_email.downcase }

  def mark_complete()
    if self.status == CAMP_INPROGRESS && self.update_column(:status, CAMP_COMPLETED)
      Notification.create(:note => 'Campaign ' + self.title + ' has completed', :user_id => self.user_id)
    end
  end
  
  def start()
    if self.status == CAMP_INPROGRESS || self.status == CAMP_QUEUED
      return -2
    end
    begin
      subscription = Subscription.find_by_user_id(self.user_id)
      total_target = Recipient.where(recipient_group_id: self.recipient_group_ids).count

      if (!subscription) 
        return -1
      elsif (subscription.name == 'credit')
        if (subscription.used >= subscription.total) 
            #self.update_column(:status, CAMP_COMPLETED)
            return -1
        end
      else # subscription per user

      end
      self.update_columns(status: 0, total_completed: 0)
      self.update_column(:total_target, total_target)
      if self.responses.present?
        self.responses.destroy_all
      end
    end
  end
end
