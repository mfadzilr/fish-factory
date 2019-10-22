require 'test_helper'

class PhishMailerTest < ActionMailer::TestCase
  test "sent_email" do
    mail = PhishMailer.sent_email
    assert_equal "Sent email", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
