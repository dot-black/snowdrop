require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  test "should create user" do
    assert_difference('User.count') do
      post users_url, params: {
        user: {
          email: 'test@email.com',
        }
      }
    end
  end
end
