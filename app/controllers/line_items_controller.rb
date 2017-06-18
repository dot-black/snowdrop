class LineItemsController < ApplicationController
  before_action :set_line_item, only: [:update, :destroy]
  include CurrentCart
  before_action :_set_cart, only: [:create]


  def create
    product = Product.find(params[:line_item][:product_id])
    @line_item = @cart.add_product(permitted_line_item_params)
    respond_to do |format|
      if @line_item.save
        format.html { redirect_to product_path(product) }
        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render :new }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @line_item.update(permitted_line_item_params)
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { render :edit }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @line_item.destroy
    respond_to do |format|
      format.html { redirect_to cart_path }
      format.json { head :no_content }
    end
  end

  private

    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    def permitted_line_item_params
      params.require(:line_item).permit(:product_id, :quantity, :size)
    end

end
