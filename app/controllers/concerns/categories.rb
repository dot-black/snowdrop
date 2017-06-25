module Categories
  private
    def _set_categories
      # @categories = manager_signed_in? ? Category.all : Category.visible #Manager can see all categories regardless it visible or hiden
      @categories = Category.visible
    end
end
