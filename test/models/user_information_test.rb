require 'test_helper'

class UserInformationTest < ActiveSupport::TestCase

  setup do
    @user = users(:first)
  end

  def new_user_information
    @user.user_informations.new(
      name: "Daniel Defoe",
      telephone: "+357233423453"
    )
  end


  test "user should not be created without name" do
    user = new_user_information
    user.name = ""
    assert user.invalid?
    user.errors[:name]
    user.name = "Daniel Defoe"
    assert user.valid?
  end

  test "user can not be created without correct telephone" do
    user = new_user_information
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
