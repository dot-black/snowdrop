class Product < ApplicationRecord
  include Filterable
  attribute :description
  translates :description
  mount_uploaders :images, ProductImageUploader

  enum size: {
    standard: [ "XS", "S", "M", "L", "XL"],
    bra:      [ "70A", "70B", "70C", "75A", "75B", "75C", "75D", "80B", "80C", "85B", "85C" ]
  }
  enum priority: { hi: 1, mid: 2, low: 3 }

  has_many :line_items
  has_many :orders, through: :line_items
  belongs_to :category
  belongs_to :discount, optional: true

  validates :title, :description, :category, :sizes, presence: true
  validates :price, numericality: {
    greater_than_or_equal_to: 0.01,
    message: I18n.translate('activerecord.errors.messages.invalid_price')
  }
  #Client scopes
  default_scope { order priority: :asc }
  scope :shown,             -> { where arel_table[:archive].eq(false), arel_table[:visible].eq(true), arel_table[:category_id].in(Category.visible.ids) }
  scope :category,          -> (category_id) { where arel_table[:category_id].eq(category_id), arel_table[:archive].eq(false), arel_table[:visible].eq(true) }
  #Manager scopes
  scope :relevant,          -> { where(arel_table[:archive].eq(false)).reorder created_at: :desc }
  scope :archival,          -> { where(arel_table[:archive].eq(true)) .reorder created_at: :desc }
  scope :visible,           -> { where(arel_table[:archive].eq(false), arel_table[:visible].eq(true))  .reorder created_at: :desc }
  scope :hidden,            -> { where(arel_table[:archive].eq(false), arel_table[:visible].eq(false)) .reorder created_at: :desc }

  scope :manager_category,  -> (category_id) { where(arel_table[:category_id].eq(category_id), arel_table[:archive].eq(false)).reorder created_at: :desc }

  def discount_price
    if discount and discount.actual
      (price * (1 - discount.value * 0.01)).round(2)
    else
      price
    end
  end
end
