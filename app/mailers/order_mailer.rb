class OrderMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.client_information.subject
  #
  def client_information order
    @order = order
    mail to: order.email, subject: "ARI DAR LINGERIE order #{order.id}"
  end

  def client_confirmation order
    @order = order
    mail to: order.email,
         subject: "ARI DAR LINGERIE order #{order.id}"
  end

  def manager_information order
    @order = order
    mailto = Rails.env.production? ?  ENV['GMAIL_NAME'] : 'aridar@example.com'
    mail to: mailto,subject: "Order #{order.id} from #{order.name} / status: #{order.status}"
  end



end
