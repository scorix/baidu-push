# encoding: utf-8

require 'rspec'
require 'logger'

describe Baidu::Push::Client do

  subject { Baidu::Push::Client.setup(api_key: '',
                                      secret_key: '',
                                      logger: Logger.new(STDOUT)) }

  context 'push message' do
    it 'should push a message, sync' do
      msg = Baidu::Push::Message.new msg_keys: "#{Time.now.to_i}_test",
                                     user_id: '',
                                     message_type: 1
      msg.messages = {title: 'test', description: 'test', custom_content: {}}
      res = subject.push_msg(msg)
      expect(res.status).to eql 200
    end
  end

end