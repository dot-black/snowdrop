class LineItemsController < StoreController
  def create
    @line_item = AddProductOrUpdateQuantity.run! session: session, line_item_params: _permitted_line_item_params
    respond_to do |format|
      if @line_item.save
        _set_cart_variables
        format.html { redirect_to product_path(params[:line_item][:product_id]) }
        format.js { flash.now[:notice] = t('line_items.flash.create.success') }
      else
        format.html { redirect_to store_path, notice: t('line_items.flash.create.failure') }
      end
    end
  end

  def update
    if _set_line_item
      respond_to do |format|
        if @line_item.update _permitted_line_item_params
          _set_cart_variables
          format.html { redirect_to new_order_path }
          format.js
        else
          format.html { redirect_to cart_path, notice: t('line_items.flash.update.failure') }
        end
      end
    else
      redirect_to store_path, notice: t('line_items.flash.update.failure')
    end
  end

  def destroy
    if _set_line_item
      respond_to do |format|
        if @line_item.destroy
          _set_cart_variables
          format.html { redirect_to cart_path }
          format.js
        else
          format.html { redirect_to cart_path, notice: t('line_items.flash.destroy.failure') }
        end
      end
    else
      redirect_to store_path, notice: t('line_items.flash.destroy.failure')
    end
  end

  private

  def _permitted_line_item_params
    params.require(:line_item).permit :product_id,
                                      :quantity,
                                      size: [:bra, :panties, :standard]
  end

  def _set_line_item
    @line_item = LineItem.find_by_id params[:id]
  end
end
