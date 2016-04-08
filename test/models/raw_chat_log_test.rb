require 'test_helper'

class RawChatLogTest < ActiveSupport::TestCase
  test "nick is downcased on saving" do
    log = RawChatLog.first
    log.nick = 'CAPNICK'
    log.save
    assert_equal 'capnick', log.nick
  end
end
