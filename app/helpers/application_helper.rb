module ApplicationHelper
  def default_or_first_image product
    product.images.empty? ? "default/default_product_image.png" : product.images.first.url
  end

  def category_image image, thumb = false
    if image.present?
      thumb ? image.thumb : image.url
    else
      thumb ? "default/default_category_thumb.png" : "default/default_category_image.png"
    end
  end
end
