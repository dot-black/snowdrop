class Category < ApplicationRecord
  has_many :products, dependent: :destroy

  attribute :title
  attribute :slug
  attribute :image
  translates :title
  mount_uploader :image, CategoryImageUploader

  validates :title, :slug, :image, presence: true
  validates_format_of :slug, with: /\A[[a-z]\s\']+\z/
  validates :slug, uniqueness: { case_sensitive: false }

  scope :visible, -> { where arel_table[:visible].eq true  }
  scope :hidden,  -> { where arel_table[:visible].eq false }
end
