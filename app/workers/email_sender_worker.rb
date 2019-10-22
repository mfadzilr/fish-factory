class EmailSenderWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(recipient_id, campaign_id)
    PhishMailer.sent_email(recipient_id, campaign_id)
  end
end
