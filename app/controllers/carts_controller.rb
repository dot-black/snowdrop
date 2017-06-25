class CartsController < ApplicationController
  include CurrentCart
  before_action :_set_cart, only: [:show, :destroy]
  # rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart

  def show
    _set_cart_line_items
    _set_cart_total_amount @line_items
    _set_cart_counter @line_items
  end

  def destroy
    @cart.destroy if @cart.id == session[:cart_id]
    session[:cart_id] = nil
    respond_to do |format|
      format.html { redirect_to store_url}
      format.json { head :no_content }
      format.js
    end
  end

  private

    # def invalid_cart
    #   logger.error "Attempt to access invalid cart #{params[:id]}" redirect_to products_path
    # end
end
