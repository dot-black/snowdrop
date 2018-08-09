class Category < ApplicationRecord
  include Translateable
  translate [:title, :slug]
  has_many :translations, as: :translateable
  has_many :products, dependent: :destroy
  has_many :translations, as: :translateable

  SLUG_REGEX = /\A[[a-z]\s\']+\z/

  mount_uploader :image, CategoryImageUploader

  validates :title, :slug, :image, presence: true
  validates :slug, format: { with: SLUG_REGEX }, uniqueness: true

  scope :visible, -> { where arel_table[:visible].eq true  }
  scope :hidden,  -> { where arel_table[:visible].eq false }

  accepts_nested_attributes_for :translations
end
