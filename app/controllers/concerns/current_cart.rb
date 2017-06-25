module CurrentCart
  private
    def _set_cart
      @cart = Cart.find session[:cart_id]
    rescue ActiveRecord::RecordNotFound
      @cart = Cart.create
      session[:cart_id] = @cart.id
    end

    def _ensure_cart_isnt_empty
      if @cart.line_items.empty?
        flash[:notice] = "Please add something to cart."
        redirect_to store_path
      end
    end

    def _destroy_cart
      Cart.destroy session[:cart_id]
      session[:cart_id] = nil
    end

    def _get_line_items_amount(line_items)
        line_items ? line_items.map(&:product).map(&:price).zip(line_items.map(&:quantity)).map{|x, y| x * y }.inject(0, &:+) : 0
    end

    def _set_cart_counter(line_items)
      @cart_line_items_quantity = line_items ? line_items.sum(:quantity) : 0
    end

    def _set_cart_total_amount(line_items)
      @total = _get_line_items_amount(line_items)
    end

    def _set_cart_line_items
      @line_items = @cart.line_items
    end
end
