class StoreController < ApplicationController
  def index
  @categories = manager_signed_in? ? Category.all : Category.visible
  end

end
