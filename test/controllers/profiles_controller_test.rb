require 'test_helper'

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:t27duck)
    @user = users(:t27duck)
  end

  test "should get show" do
    get profile_url
    assert_response :success
  end

  test "should update profile" do
    patch profile_url, params: {
      user: { password: '12345678', password_confirmation: '12345678' }
    }
    assert_redirected_to root_path
  end

  test "should not update invalid profile" do
    patch profile_url params: {
      user: { password: '1234' }
    }
    assert_response :success
  end
end
