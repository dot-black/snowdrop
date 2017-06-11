class StoreController < ApplicationController
  def index
    @categories = Category.visible
  end

end
