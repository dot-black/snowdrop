require 'active_interaction'

class UpdateUser < ActiveInteraction::Base
  object :user

  string :name, :telephone, :email,
    default: nil

  validates :name,
    presence: true,
    if: :name?

  validates :telephone,
    presence: true,
    if: :telephone?

  validates :email,
    presence: true,
    if: :email?

  def execute
    user.name = name if name?
    user.telephone = telephone if telephone?
    user.email = email if email?

    errors.merge!(thing.errors) unless user.save

    user
  end

end
