require 'active_interaction'

class CheckUserByEmail < ActiveInteraction::Base
  string :email

  validates :email,
    presence: true,
    if: :email?

  def execute
    User.find_by_email(email)
  end

end
