class CartsController < ApplicationController
  include CurrentCart
  before_action :_set_cart, only: [:show, :destroy]

  # rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart

  def show
    @line_items = @cart.line_items
    @total = @line_items.map(&:product).map(&:price).zip(@line_items.map(&:quantity)).map{|x, y| x * y }.inject(0, &:+)
  end

  def destroy
    @cart.destroy if @cart.id == session[:cart_id]
    session[:cart_id] = nil
    respond_to do |format|
      format.html { redirect_to carts_url, notice: 'Cart was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # def invalid_cart
    #   logger.error "Attempt to access invalid cart #{params[:id]}" redirect_to products_path
    # end
end
