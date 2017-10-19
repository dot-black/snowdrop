class User < ApplicationRecord
  has_many :orders
  has_many :user_informations

  validates_uniqueness_of :email, case_sensitive: false
  validates_format_of     :email, with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  scope :search_by_email, -> (query) { where arel_table[:email].lower.matches("#{query}%") }
  scope :search_by_name_or_email_or_telephone, -> (query)   { joins(:user_informations).merge(
                                                              search_by_email(query)
                                                              .or(UserInformation.search_by_telephone(query))
                                                              .or(UserInformation.search_by_name(query)))}

  paginates_per 20
end
