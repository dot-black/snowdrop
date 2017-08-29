require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    @user = users(:first)
  end


  def new_user
    User.new(
      name: "Daniel Defoe",
      email: "daniel.defoe@example.com",
      telephone: "+357233423453"
    )
  end

  test "user should not be created without name" do
    user = new_user
    user.name = ""
    assert user.invalid?
    user.errors[:name]
    user.name = "Daniel Defoe"
    assert user.valid?
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


  test "user can not be created without correct telephone" do
    user = new_user
    user.telephone = ""
    assert user.invalid?
    user.errors[:telephone]
    user.telephone = "5345"
    assert user.invalid?
    user.errors[:telephone]
    user.telephone = "534543453453443500000"
    assert user.invalid?
    user.errors[:telephone]
    user.telephone = "380631001010"
    assert user.valid?
  end

end
