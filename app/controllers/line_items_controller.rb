class LineItemsController < ApplicationController
  include CurrentCart
  before_action :_set_line_item, only: [:update, :destroy]
  before_action :_set_cart, only: [:create, :update, :destroy]
  before_action :_ensure_cart_isnt_empty, only: :update

  def create
    product = Product.find(params[:line_item][:product_id])
    @line_item = @cart.add_product(_permitted_line_item_params)
    respond_to do |format|
      if @line_item.save
        _set_cart_line_items
        _set_cart_counter @line_items
        format.html { redirect_to product_path(product) }
        format.json { render :show, status: :created, location: @line_item }
        format.js
      else
        flash[:warning] = "Product wasn't added"
        format.html { redirect_to store_url }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @line_item.update _permitted_line_item_params
        _set_cart_line_items
        _set_cart_total_amount @line_items
        _set_cart_counter @line_items
        format.html { redirect_to new_order_path }
        format.json
        format.js
      else
        flash[:warning] = "Can't update line item!"
        format.html { redirect_to cart_path }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end

  end

  def destroy
    respond_to do |format|
      if @line_item.destroy
        _set_cart_line_items
        _set_cart_total_amount @line_items
        _set_cart_counter @line_items
        format.html { redirect_to cart_path }
        format.json { head :no_content }
        format.js
      else
        flash[:warning] = "Can't destroy line item!"
        format.html { redirect_to cart_path }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def _permitted_line_item_params
      params.require(:line_item).permit(:product_id, :quantity, size:[:bra, :brief, :standard])
    end

    def _set_line_item
      @line_item = LineItem.find(params[:id])
    end
end
