require 'test_helper'

class OrderMailerTest < ActionMailer::TestCase
  setup do
    @order = orders(:one)
  end

  test "client_information" do
    mail = OrderMailer.client_information @order
    assert_equal "ARI DAR LINGERIE order", mail.subject
    assert_equal [ @order.email ], mail.to
    # assert_equal ["from@example.com"], mail.from
    # assert_match "Hi", mail.body.encoded
  end

  test "manager_information" do
    mail = OrderMailer.manager_information @order
    assert_equal "Order #{@order.id} from #{@order.name} / status: #{@order.status}", mail.subject
    # assert_equal ["to@example.org"], mail.to
    # assert_equal ["from@example.com"], mail.from
    # assert_match "Hi", mail.body.encoded
  end

  test "client_confirmation" do
    mail = OrderMailer.client_confirmation @order
    assert_equal "ARI DAR LINGERIE order", mail.subject
    assert_equal [ @order.email ], mail.to
    # assert_equal ["from@example.com"], mail.from
    # assert_match "Hi", mail.body.encoded
  end

end
