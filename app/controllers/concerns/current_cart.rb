module CurrentCart

  private
    def _set_cart
      @cart = Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
      @cart = Cart.create
      session[:cart_id] = @cart.id
    end

    def _ensure_cart_isnt_empty
       redirect_to store_path if @cart.line_items.empty?
    end

    def _destroy_cart
      Cart.destroy(session[:cart_id])
      session[:cart_id] = nil
    end
end
