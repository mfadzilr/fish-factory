class PhishMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.phish_mailer.sent_email.subject
  #
  rescue_from 'StandardError' do |e|
    update_send_status(e)
  end
  rescue_from 'Exception' do |e|
    update_send_status(e)
  end

  include Sidekiq::Worker
  sidekiq_options retry: false

  attr_accessor :res_id
  attr_accessor :subs

  def sent_email(recipient_id, campaign_id, response_id)

    campaign = Campaign.find(campaign_id)
    recipient = Recipient.find(recipient_id)
    attachment_file = AttachmentFile.find(campaign.attachment_file_id) rescue nil
    response = Response.find(response_id)
    smtp_settings = SendProfile.find(campaign.send_profile_id) rescue nil
    subscription = Subscription.find_by_user_id(campaign.user_id)
    self.res_id = response.id
    self.subs = subscription

    if (response.status == RESP_CANCELLED) 
      response.update(status: -1, error_message: 'User aborted.')
      campaign.update_column(:status, CAMP_COMPLETED)
      if subscription.name == 'credit'
          subscription.decrement!(:used) # give credit back
      end
      return
    end
    
    response.update(status: RESP_SENDING)

    # Prepare message-id
    name, domain = campaign.sender_email.split("@")
    headers['Message-ID'] = "#{SecureRandom.hex()[0..9]}.#{SecureRandom.hex()[0..7]}-#{SecureRandom.hex()[0..9]}.#{SecureRandom.hex()[0..7]}-#{SecureRandom.random_number(9999999999999)}@#{domain}"

    email_template = EmailTemplate.find(campaign.email_template_id)
    email_from_with_name = %("#{campaign.sender_name}" <#{campaign.sender_email}>)
    email_to_with_name = %("#{recipient.full_name}" <#{recipient.email_to}>)

    content = email_template.content

    if campaign.site_address.present?
      phishing_site_url = campaign.site_address
    else
      phishing_site_url = root_url
    end
    # replace tag
    # a.match(/(\{{(URL|.*)\}})/)[2].split('|')
    subject = campaign.sender_subject.gsub /{{USER}}/i, recipient.full_name
    content = content.gsub /{{USER}}/i, recipient.full_name
    content = content.gsub /{{DOMAIN}}/i, domain
    content = content.gsub /{{PHISH_URL}}/i, %(<a href="#{phishing_site_url + 'links/' + response.token}"><u>here</u></a>)
    content = content.gsub /{{PHISH_RAW_URL}}/i, %(#{phishing_site_url + 'links/' + response.token})

    if attachment_file
      content = content.gsub /{{DOWNLOAD_URL}}/i, %(<a href="#{phishing_site_url + attachment_file.payload.url}"><u>here</u></a>)
    end

    content = content.gsub /{{SITE_URL}}/i, %(#{phishing_site_url})

    hidden_image = %(<img src="#{phishing_site_url + 'images/' + response.token + '.jpg'}" alt="#{domain + ' logo'}" />)
    
    # file attachment
    if campaign.attach_file? && !attachment_file.nil?
      attachments[attachment_file.payload_file_name] = File.read(attachment_file.payload.path)
    end

    settings = {
        :address => smtp_settings.address,
        :port => smtp_settings.port,
        :user_name => smtp_settings.user_name,
        :password => smtp_settings.password,
        :authentication => smtp_settings.authentication
      }

    # mail  delivery_method_options: settings,
    #       to: email_to_with_name,
    #       from: email_from_with_name,
    #       subject:subject do |format|
    #         format.html { render plain: content + hidden_image }
    #       end

    campaign.increment!(:total_completed)
    response.update(status: RESP_SENT)
    

    # res = Response.where("campaign_id = ? and status <> ?", campaign_id, 1)
    # if res.count == 0 
    #   campaign.update_column(:status, CAMP_COMPLETED)
    #   Notification.create(:note => 'Campaign ' + campaign.title + ' has completed', :user_id => campaign.user_id)
    # end
    
    # if campaign.total_completed >= campaign.total_target || campaign.total_completed >= subscription.total 
    # campaign.update_column(:status, CAMP_COMPLETED)
    # end

    # res = Response.where("campaign_id = ? and status <> ?", campaign_id, 1)
    # if res.count == 0 
    #   campaign.update_column(:status, CAMP_COMPLETED)
    #   Notification.create(:note => 'Campaign ' + campaign.title + ' has completed', :user_id => campaign.user_id)
    # end
   

    
  end

  def update_send_status(e)
      if self.res_id
        response = Response.find(self.res_id);
        # TODO : requeue or retry for certain network errors
        # status = -1 (failed)
        response.update(status: RESP_FAILED, error_message: e.class.to_s + ' : ' + e.message)
        campaign = Campaign.find(response.campaign_id)
        campaign.increment!(:total_completed)
        
        if (campaign.total_completed >= campaign.total_target) 
          campaign.update_column(:status, CAMP_COMPLETED)
        end

      end
      if self.subs
        if self.subs.name == 'credit'
          self.subs.decrement!(:used)
        end
      end
  end

end
