require 'test_helper'

class NickWhitelistsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:t27duck)
    @nick_whitelist = nick_whitelists(:t527duck)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create nick_whitelist" do
    assert_difference('NickWhitelist.count') do
      post :create, params: { nick_whitelist: { nick: 'new_nick' } }
    end

    assert_redirected_to nick_whitelist_path(NickWhitelist.last)
  end

  test "should not create invalid nick_whitelist" do
    assert_no_difference('NickWhitelist.count') do
      post :create, params: { nick_whitelist: { nick: '' } }
    end

    assert_response :success
  end


  test "should show nick_whitelist" do
    get :show, params: { id: @nick_whitelist }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @nick_whitelist }
    assert_response :success
  end

  test "should update nick_whitelist" do
    process :update, method: :post, params: {
      id: @nick_whitelist,
      nick_whitelist: { nick: @nick_whitelist.nick }
    }
    assert_redirected_to nick_whitelist_path(@nick_whitelist)
  end

  test "should not update invalid nick_whitelist" do
    process :update, method: :post, params: {
      id: @nick_whitelist,
      nick_whitelist: { nick: '' }
    }
    assert_response :success
  end

  test "should destroy nick_whitelist" do
    assert_difference('NickWhitelist.count', -1) do
      delete :destroy, params: { id: @nick_whitelist }
    end

    assert_redirected_to nick_whitelists_path
  end
end
