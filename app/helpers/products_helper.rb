module ProductsHelper
  def first_image product
    product.images == [] ?  "products/default.png" : product.images.first
  end

end
