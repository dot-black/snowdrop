require 'active_interaction'

class FetchUser < ActiveInteraction::Base
  integer :id

  validates :id,
    presence: true,
    if: :id?

  def execute
    user = User.find_by_id(id)
    errors.add(:id, :not_found) unless user
    user
  end

end
