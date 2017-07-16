class Product < ApplicationRecord
  enum size: {
     standard: [ "XS", "S", "M", "L", "XL"],
     bra: [ "70A", "70B", "70C", "75A", "75B", "75C", "75D", "80B", "80C", "85B", "85C" ]
  }

  enum priority: { hi: 1, mid: 2, low: 3 }

  validates :title, :description, :category, :sizes, presence: true
  validates :price, numericality: {
    greater_than_or_equal_to: 0.01,
    message:'incorrect, please enter a value at least greater then 0.01 or equal one'
  }
  has_many :line_items
  has_many :orders, through: :line_items
  belongs_to :category

  mount_uploaders :images, ProductImageUploader

  #Manager scopes
  scope :relevant, -> { where( archive: false ).reorder( created_at: :desc ) }
  scope :visible, -> { where( visible: true, archive: false ).reorder( created_at: :desc ) }
  scope :hiden, -> { where( visible: false, archive: false ).reorder( created_at: :desc ) }
  scope :archival, -> { where( archive: true ).reorder( created_at: :desc ) }
  #Client scopes
  default_scope { order( priority: :asc ) }
  scope :shown, -> { where( archive: false, visible: true,  category_id: Category.visible.ids ) }
  scope :category, -> (category_id) { where( category_id: category_id, archive: false, visible: true ) }


  def sizes_collection
    self.sizes.map{|s|[Product.sizes.key(s).to_s.upcase,s]}
  end

end
