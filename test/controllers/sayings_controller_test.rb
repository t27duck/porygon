require 'test_helper'

class SayingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:t27duck)
    @saying = sayings(:one)
  end

  test "should get index" do
    get sayings_url
    assert_response :success
  end

  test "should get new" do
    get new_saying_url
    assert_response :success
  end

  test "should create saying" do
    assert_difference('Saying.count') do
      post sayings_url, params: {
        saying: {
          enabled: "true",
          name: "New name",
          pattern: "A pattern",
          trigger_percentage: "100"
        }
      }
    end

    assert_redirected_to saying_path(Saying.last)
  end

  test "should not create invalid saying" do
    assert_no_difference('Saying.count') do
      post sayings_url, params: {
        saying: {
          pattern: "A pattern"
        }
      }
    end

    assert_response :success
  end

  test "should show saying" do
    get saying_url(@saying)
    assert_response :success
  end

  test "should get edit" do
    get edit_saying_url(@saying)
    assert_response :success
  end

  test "should update saying" do
    patch saying_url(@saying), params: {
      saying: {
        enabled: @saying.enabled,
        name: @saying.name,
        pattern: @saying.pattern,
        trigger_percentage: @saying.trigger_percentage
      }
    }
    assert_redirected_to saying_path(@saying)
  end

  test "should not update invalid saying" do
    patch saying_url(@saying), params: {
      id: @saying.id,
      saying: {
        pattern: ''
      }
    }
    assert_response :success
  end

  test "should destroy saying" do
    assert_difference('Saying.count', -1) do
      delete saying_url(@saying)
    end

    assert_redirected_to sayings_path
  end
end
