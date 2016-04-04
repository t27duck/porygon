require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'user can be created' do
    assert_difference 'User.count' do
      User.create!(
        username: 'newuser',
        password: '12345678',
        password_confirmation: '12345678'
      )
    end
  end
end
