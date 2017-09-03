require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @user = users(:first)
    sign_in managers(:first) #Login as manager
  end


  test "should show all users" do
    get manager_users_path
    assert_response :success
  end


  test "should filter by search query" do
    get manager_users_path(search_query: "something"), xhr: true
    assert_response :success
    assert_equal "text/javascript", @response.content_type
  end

  test "should show user" do
    get manager_user_path @user
    assert_response :success
  end

end
