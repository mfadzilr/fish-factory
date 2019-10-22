class User < ApplicationRecord

  has_many  :recipient_groups, dependent: :destroy
  has_many  :email_templates, dependent: :destroy
  has_many  :send_profiles, dependent: :destroy
  has_many  :campaigns, dependent: :destroy
  has_many  :attachment_files, dependent: :destroy
  has_many  :site_pages, dependent: :destroy
  has_many  :reports, dependent: :destroy
  has_one   :subscription, foreign_key: :user_id, dependent: :destroy
  has_many  :notifications, foreign_key: :user_id, dependent: :destroy

  has_many :unread_notifications, -> { where(read: false).order("id desc").limit(10) }, class_name: "Notification"

  accepts_nested_attributes_for :subscription
  # has_many  :responses, through: :campaigns
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  
  # attr_accessor :subscription

  def active_for_authentication?
   #remember to call the super
   #then put our own check to determine "active" state using
   #our own "is_active" column
   super and self.is_active?
  end

end
