require 'test_helper'

class OrderMailerTest < ActionMailer::TestCase
  setup do
    @order = orders(:one)
  end
  I18n.available_locales.each do |locale|
    I18n.locale = locale
    test "client_information  #{locale}" do
      mail = OrderMailer.client_information @order
      assert_equal I18n.translate('order_mailer.client_information.subject'), mail.subject
      assert_equal [ @order.user.email ], mail.to
      # assert_equal ["from@example.com"], mail.from
      # assert_match "Hi", mail.body.encoded
    end
    test "manager_information #{locale}" do
      mail = OrderMailer.manager_information @order
      assert_equal "New order ##{@order.id}", mail.subject
      # assert_equal ["to@example.org"], mail.to
      # assert_equal ["from@example.com"], mail.from
      # assert_match "Hi", mail.body.encoded
    end
  end
  test "client_confirmation" do
    I18n.locale  = @order.locale
    mail = OrderMailer.client_confirmation @order
    assert_equal I18n.translate('order_mailer.client_confirmation.subject'), mail.subject
    assert_equal [ @order.user.email ], mail.to
    # assert_equal ["from@example.com"], mail.from
    # assert_match "Hi", mail.body.encoded
  end
end
