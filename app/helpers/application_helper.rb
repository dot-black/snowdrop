module ApplicationHelper
  def first_image product
    product.images == [] ?  "default/default_product_image.png" : product.images.first
  end

  def category_image image, thumb = false
    if image.present?
      thumb ? image.thumb : image
    else
      thumb ? "default/default_category_thumb.png" : "default/default_category_image.png"
    end
  end
end
