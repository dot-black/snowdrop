module LineItemsAmount

  private

    def _get_line_items_amount(line_items)
      line_items.map(&:product).map(&:price).zip(line_items.map(&:quantity)).map{|x, y| x * y }.inject(0, &:+)
    end

end
