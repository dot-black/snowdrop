class Order < ApplicationRecord
  include Filterable
  enum status: { pending: 0, accepted: 1, declined: 2, completed: 3 }

  has_many :line_items, dependent: :destroy
  belongs_to :user
  belongs_to :user_information

  validates :comment, length: { maximum: 500 }

  scope :filter_status, ->(status)  { where(status: status).reorder created_at: :desc }
  paginates_per 20

  def self.search_by_name_or_email_or_telephone query
    joins(:user_information, :user).merge(UserInformation.search_by_telephone(query)
                                   .or(UserInformation.search_by_name(query))
                                   .or(User.search_by_email(query)))
  end
end
