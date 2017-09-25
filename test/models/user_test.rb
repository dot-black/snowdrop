require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    @user = users(:first)
  end


  def new_user
    User.new email: "daniel.defoe@example.com"
  end
  test "user can not be created without correct email" do
    user = new_user
    user.email = ""
    assert user.invalid?
    user.errors[:email]
    user.email = "231.dsd"
    assert user.invalid?
    user.errors[:email]
    user.email = "ddfs@."
    assert user.invalid?
    user.errors[:email]
    user.email = "daniel.defoe@gmail.com"
    assert new_user.valid?
  end

end
