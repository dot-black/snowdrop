require 'active_interaction'

# Create a new user.
class CreateUser < ActiveInteraction::Base
  string :email, :name, :telephone

  validates :email, :name, :telephone,
    presence: true

  # Make this interaction work as a form object.
  def to_model
    ::User.new
  end

  def execute
    user = User.new(inputs)
    errors.merge!(user.errors) unless user.save
    user
  end
end
