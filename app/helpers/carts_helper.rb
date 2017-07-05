module CartsHelper
  def get_string_of_line_item_title_and_size line_item
    "#{line_item.product.title.gsub " ", "_"}-#{line_item.size.values.join('-')}"
  end
end
