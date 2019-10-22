class Response < ApplicationRecord
  belongs_to  :campaign
  belongs_to  :recipient
  has_many    :recipient_details, dependent: :destroy

  before_create :generate_token
  after_commit :check_completion

  private


  def check_completion
    Campaign.transaction do 
      campaign = Campaign.where("id = ? ", self.campaign_id).lock(true).first
      if (campaign.status == CAMP_INPROGRESS)
      
      #File.open("/tmp/check_completion_debug", "a+") { |f| f.puts 'C status: ' +  campaign.status.to_s + ', C total_completed : ' + campaign.total_completed.to_s }

        if campaign.total_completed == campaign.total_target
          campaign.mark_complete
        end
      end
    end
  end

  def generate_token
    begin
      self.token = SecureRandom.hex
    end while self.class.exists?(token: token)
  end

end
