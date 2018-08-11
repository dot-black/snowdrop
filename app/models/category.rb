class Category < ApplicationRecord
  SLUG_REGEX = /\A[[a-z]\-]+\z/
  TRANSLATEABLE_ATTRBUTES = [:title].freeze

  include Translateable
  translate TRANSLATEABLE_ATTRBUTES
  has_many :translations, as: :translateable
  has_many :products, dependent: :destroy

  mount_uploader :image, CategoryImageUploader

  validates :title, :slug, :image, presence: true
  validates :slug, format: { with: SLUG_REGEX }, uniqueness: true

  default_scope { includes(:translations) }
  scope :visible, -> { where arel_table[:visible].eq true  }
  scope :hidden,  -> { where arel_table[:visible].eq false }

  accepts_nested_attributes_for :translations, reject_if: :all_blank

  after_create :add_translations
end
