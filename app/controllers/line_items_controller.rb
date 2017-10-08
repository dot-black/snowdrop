class LineItemsController < StoreController
  def create
    @line_item = AddProductOrUpdateQuantity.run! session: session, line_item_params: _permitted_line_item_params
    respond_to do |format|
      if @line_item.save
        _set_line_items_variables
        format.html { redirect_to product_path(params[:line_item][:product_id]) }
        format.json { render :show, status: :created, location: @line_item }
        format.js {flash.now[:notice] = t 'line_items.flash.create.success'}
      else
        flash[:warning] = t 'line_items.flash.create.failure'
        format.html { redirect_to store_path}
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    # _ensure_cart_isnt_empty
    _set_line_item
    respond_to do |format|
      if @line_item.update _permitted_line_item_params
        _set_line_items_variables
        format.html { redirect_to new_order_path }
        format.json
        format.js
      else
        flash[:warning] = t 'line_items.flash.update.failure'
        format.html { redirect_to cart_path }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end

  end

  def destroy
    _set_line_item
    respond_to do |format|
      if @line_item.destroy
        _set_line_items_variables
        format.html { redirect_to cart_path }
        format.json { head :no_content }
        format.js
      else
        flash[:warning] = t 'line_items.flash.destroy.failure'
        format.html { redirect_to cart_path }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def _permitted_line_item_params
      params.require(:line_item).permit(:product_id, :quantity, size:[:bra, :panties, :standard])
    end

    def _set_line_item
      outcome = FetchLineItem.run(params)
      if outcome.valid?
        @line_item = outcome.result
      else
        raise ActiveRecord::RecordNotFound,
          outcome.errors.full_messages.to_sentence
      end
    end
end
