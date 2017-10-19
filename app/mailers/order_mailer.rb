class OrderMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.client_information.subject
  #
  def client_information order
    @order = order
    I18n.locale = @order.locale
    mail to: order.user.email, subject: t('order_mailer.client_information.subject')
  end

  def client_confirmation order
    @order = order
    I18n.locale = @order.locale
    mail to: order.user.email,
         subject: t('order_mailer.client_confirmation.subject')
  end

  def manager_information order
    @order = order
    mailto = Rails.env.production? ?  ENV['GMAIL_NAME'] : 'aridar@example.com'
    mail to: mailto,subject: "New order ##{order.id}"
  end



end
