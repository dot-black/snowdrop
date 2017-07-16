class OrderMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.client_information.subject
  #
  def client_information order
    @order = order
    mail to: order.email, subject: "ARI DAR LINGERIE order"
  end


  def manager_information order
    @order = order
    if Rails.env.production?
      mail to: ENV['GMAIL_NAME'],subject: "Order #{order.id} from #{order.name} / status: #{order.status}"
    else
      mail to: 'vdavyden@gmail.com',subject: "Order #{order.id} from #{order.name} / status: #{order.status}"
    end
  end


  def client_confirmation order
    @order = order
    mail to: order.email,
         subject: "ARI DAR LINGERIE order"
  end
end
