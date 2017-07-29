# Preview all emails at http://localhost:3000/rails/mailers/order_mailer
class OrderMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/order_mailer/client_information
  def client_information
    OrderMailer.client_information Order.first
  end

  # Preview this email at http://localhost:3000/rails/mailers/order_mailer/client_confirmation
  def client_confirmation
    OrderMailer.client_confirmation Order.first
  end

  # Preview this email at http://localhost:3000/rails/mailers/order_mailer/manager_information
  def manager_information
    OrderMailer.manager_information Order.first
  end

end
