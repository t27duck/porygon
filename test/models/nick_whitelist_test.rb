require 'test_helper'

class NickWhitelistTest < ActiveSupport::TestCase
  test ".includes? looks up by whitelisted nick" do
    nick_whitelist = NickWhitelist.first
    assert NickWhitelist.includes?(nick_whitelist.nick)
  end
end
