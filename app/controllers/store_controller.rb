class StoreController < ApplicationController
  include CurrentCart
  before_action :_set_cart, only: :index
  before_action :_set_cart_counter, only: :index

  def index
    # @categories = manager_signed_in? ? Category.all : Category.visible #Manager can see categories regardles it visible or hiden
    @categories = Category.visible
  end

end
