require 'test_helper'

class UserInformationsControllerTest < ActionDispatch::IntegrationTest

  test "should create information" do
    post users_url, params: {
      user: {
        email: 'test@email.com',
      }
    }
    assert_difference('UserInformation.count') do
      post user_informations_url, params: {
        user_information: {
          name: 'some name',
          telephone: '380635444849',
        }
      }
    end
  end
end
