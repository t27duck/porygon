require 'test_helper'

class ChatDataParserTest < ActiveSupport::TestCase
  test 'raw logs are all marked as parsed' do
    refute RawChatLog.message.all?{ |x| x.parsed }
    ChatDataParser.new.parse
    assert RawChatLog.message.all?{ |x| x.parsed }
  end
end
