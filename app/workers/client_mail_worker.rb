class ClientMailWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(order_id)
    order = Order.find_by_id order_id
    OrderMailer.client_information(order).deliver if order
    puts "CLIENT MAIL SEND" if order
  end

end
