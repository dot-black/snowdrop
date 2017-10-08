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


  test "user_information should not be created without name" do
    info = new_user_information
    info.name = ""
    assert info.invalid?
    info.errors[:name]
    info.name = "Daniel Defoe"
    assert info.valid?
  end

  test "user_information can not be created without correct telephone" do
    info = new_user_information
    info.telephone = ""
    assert info.invalid?
    info.errors[:telephone]
    info.telephone = "5345"
    assert info.invalid?
    info.errors[:telephone]
    info.telephone = "534543453453443500000"
    assert info.invalid?
    info.errors[:telephone]
    info.telephone = "rfcs;ex'"
    assert info.invalid?
    info.errors[:telephone]
    info.telephone = "380631001010"
    assert info.valid?
  end

end
