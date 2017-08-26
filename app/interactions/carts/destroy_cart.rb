require 'active_interaction'

class DestroyCart < ActiveInteraction::Base
  interface :session

  def execute
    Cart.destroy session[:cart_id]
    session[:cart_id] = nil
  end

end
