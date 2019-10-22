# Preview all emails at http://localhost:3000/rails/mailers/phish_mailer
class PhishMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/phish_mailer/sent_email
  def sent_email
    PhishMailer.sent_email
  end

end
