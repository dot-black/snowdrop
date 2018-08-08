class LineItem < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :product, optional: true
  belongs_to :cart

  validates :quantity, numericality: { greater_than_or_equal_to: 1,
                                       message: I18n.translate('activerecord.errors.messages.invalid_quantity') }
  default_scope { order id: :desc }
end
