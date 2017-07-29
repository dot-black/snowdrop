module Categories
  private
    def _set_categories
      @categories = Category.visible
    end
end
