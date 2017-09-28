class ManagerMailWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(order_id)
    order = Order.find_by_id order_id
    OrderMailer.manager_information(order).deliver if order
    puts "MANAGER MAIL SEND" if order
  end

end
