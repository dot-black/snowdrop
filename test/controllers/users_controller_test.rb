require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  test "should not edit unless session exists" do
    get edit_users_path
    assert_response :redirect
  end

  test "should create user" do
    assert_difference('User.count') do
      post users_url, params: {
        user: {
          name: 'some name',
          email: 'test@email.com',
          telephone: '456789876545'
        }
      }
    end
  end

  test "should edit user" do
    post users_path, params: {
      user: {
        name: 'some name',
        email: 'test@email.com',
        telephone: '456789876545'
      }
    }
    get edit_users_path
    assert_response :success
    post update_users_path, params: {
      update_user: {
        name: 'New name',
        telephone: '666666666665'
      }
    }
    user = User.find_by_email('test@email.com')
    assert_equal user.name, "New name"
    assert_equal user.telephone, '666666666665'
  end
end
