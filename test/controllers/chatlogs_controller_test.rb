require 'test_helper'

class ChatlogsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:t27duck)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show with channel and date" do
    get :show, params: { channel: 'room1', date: '20150305' }
    assert_response :success
  end

  test "should redirect from show with channel or date missing" do
    get :show, params: { channel: 'room1', date: '' }
    assert_redirected_to chatlogs_path

    get :show, params: { channel: '', date: '20150305' }
    assert_redirected_to chatlogs_path
  end
end
