class Translation < ApplicationRecord
  belongs_to :translateable, polymorphic: true
  validates :locale, :attribute_name, uniqueness: { scope: [:translateable_id, :translateable_type] }

  validates :value, format: { with: Category::SLUG_REGEX },  if: -> { category_slug? }
  validate :uniqness_of_slug, if: -> { category_slug? }

  private

  def uniqness_of_slug
    return unless category_slug.any? || Category.where(slug: value).any?
    errors.add(:base, I18n.t("errors.format", attribute: I18n.t("activerecord.attributes.category.slug"),
                                              message: I18n.t("error.messages.is_invalid")))
  end

  def category_slug?
    attribute_name == 'slug' &&
      translateable_type == 'Category'
  end

  def category_slug
    where attribute_name: 'slug',
          translateable_type: 'Category',
          value: value
  end
end
