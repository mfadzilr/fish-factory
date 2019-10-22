class PhishingJob < ApplicationJob

  queue_as :default

  # rescue_from(ActiveRecord::RecordNotFound) do |exception|
  # end

  # def perform(*args)
  def perform(campaign_id)
    # Do something later
    campaign = Campaign.find(campaign_id)
    
    Notification.create(:note => 'Campaign ' + campaign.title + ': has started', :user_id => campaign.user_id)
    total_target = Recipient.where(recipient_group_id: campaign.recipient_group_ids).count
    
    @recipients = Recipient.where(recipient_group_id: campaign.recipient_group_ids)
    credit = Subscription.find_by_user_id(campaign.user_id)

    if (total_target > (credit.total - credit.used) || total_target > credit.total )
      Notification.create(:note => 'Subscription limit reached. Only ' + (credit.total - credit.used).to_s + ' emails will be send', :user_id => campaign.user_id)
      campaign.update_column(:total_target, (credit.total - credit.used))
    end
    campaign.update_column(:status, CAMP_INPROGRESS) 

    counter = 0;
    @recipients.each do |recipient|

      if (credit.name == 'credit' && credit.used >= credit.total ) || (credit.name == 'user' && counter >= credit.total)
        #Notification.create(:note => 'Subscription limit reached.', :user_id => campaign.user_id)
        return
      end
      
      if (credit.name == 'credit')
        credit.increment!(:used)
      end
      response = Response.create(
                    campaign_id: campaign.id, 
                    recipient_id: recipient.id, 
                    expired_at: campaign.date_end_at, 
                    status: RESP_QUEUED)
      begin
        PhishMailer.sent_email(recipient.id, campaign.id, response.id).deliver_later
        
        # EmailSenderWorker.perform_async(recipient.id, campaign.id)
      rescue  EOFError,
              IOError,
              TimeoutError,
              Errno::ECONNRESET,
              Errno::ECONNABORTED,
              Errno::EPIPE,
              Errno::ETIMEDOUT,
              Net::SMTPAuthenticationError,
              Net::SMTPServerBusy,
              Net::SMTPSyntaxError,
              Net::SMTPUnknownError,
              OpenSSL::SSL::SSLError => e
        if response
          response.update(status: RESP_FAILED, error_message:  'e => ' + e.class.to_s + ' : ' + e.message)
          if (credit.name == 'credit')
            credit.decrement!(:used)
          end
        end
      end # begin / resuce

      counter += 1
    end
  end
end
