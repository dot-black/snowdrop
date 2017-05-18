class LineItem < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :product, optional: true
  belongs_to :cart

end
