class Product < ApplicationRecord
  TRANSLATEABLE_ATTRBUTES = [:description].freeze

  include Filterable
  include Translateable
  translate TRANSLATEABLE_ATTRBUTES

  mount_uploaders :images, ProductImageUploader

  enum size: { standard: %w[XS S M L XL],
               bra:      %w[70A 70B 70C 75A 75B 75C 75D 80B 80C 85B 85C] }
  enum priority: { hi: 1, mid: 2, low: 3 }

  has_many :line_items
  has_many :orders, through: :line_items
  has_many :translations, as: :translateable
  belongs_to :category
  belongs_to :discount, optional: true

  validates :title, :description, :category, :sizes, presence: true
  validates :price, numericality: {
    greater_than_or_equal_to: 0.01,
    message: I18n.translate('activerecord.errors.messages.invalid_price')
  }
  # Client scopes
  default_scope { includes(:translations).order priority: :asc }
  scope :shown,             -> { where archive: false, visible: true, category_id: Category.visible.ids }
  scope :by_category,       ->(category_id) { where category_id: category_id, archive: false, visible: true }
  # Manager scopes
  scope :relevant,          -> { where(archive: false).reorder created_at: :desc }
  scope :archival,          -> { where(archive: true).reorder created_at: :desc }
  scope :visible,           -> { where(archive: false, visible: true).reorder created_at: :desc }
  scope :hidden,            -> { where(archive: false, visible: false).reorder created_at: :desc }
  scope :manager_category,  ->(category_id) { where(category_id: category_id, archive: false).reorder created_at: :desc }
  # Filterable scopes
  scope :filter_relevant,          ->(_) { where(archive: false).reorder created_at: :desc }
  scope :filter_archival,          ->(_) { where(archive: true).reorder created_at: :desc }
  scope :filter_visible,           ->(_) { where(archive: false, visible: true).reorder created_at: :desc }
  scope :filter_hidden,            ->(_) { where(archive: false, visible: false).reorder created_at: :desc }
  scope :filter_shown,             ->(_) { where archive: false, visible: true, category_id: Category.visible.ids }
  scope :filter_by_category,       ->(category_id) { where category_id: category_id, archive: false, visible: true }
  scope :filter_manager_category,  ->(category_id) { where(category_id: category_id, archive: false).reorder created_at: :desc }

  accepts_nested_attributes_for :translations

  after_create :add_translations

  def discount_price
    if discount.present? && discount.actual
      (price * (1 - discount.value * 0.01)).round(2)
    else
      price
    end
  end
end
