require 'test_helper'

class ChatlogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:t27duck)
  end

  test "should get index" do
    get chatlogs_url
    assert_response :success
  end

  test "should get show with channel and date" do
    get '/chatlogs/room1/20150305'
    assert_response :success
  end
end
