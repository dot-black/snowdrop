require 'test_helper'

class OrderMailerTest < ActionMailer::TestCase
  test "client_information" do
    mail = OrderMailer.client_information
    assert_equal "Client information", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "manager_information" do
    mail = OrderMailer.manager_information
    assert_equal "Manager information", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "client_confirmation" do
    mail = OrderMailer.client_confirmation
    assert_equal "Client confirmation", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
