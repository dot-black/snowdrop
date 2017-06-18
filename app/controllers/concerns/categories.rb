module Categories
  private
    def _set_categories
      @categories = manager_signed_in? ? Category.all : Category.visible
    end
end
