module ApplicationHelper
  def first_image product
    product.images == [] ?  "products/default.png" : product.images.first
  end

  def category_image image, thumb = false
    if image.present?
      thumb ? image.thumb : image
    else
      thumb ? "categories/default_thumb.png" : "categories/default.png"
    end
  end
end
