require 'active_interaction'

class GetCart < ActiveInteraction::Base
  interface :session

  def execute
    cart = Cart.find session[:cart_id]
  rescue ActiveRecord::RecordNotFound
    cart = Cart.create
    session[:cart_id] = cart.id
    cart
  end
  
end
