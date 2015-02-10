# encoding: utf-8

require 'rspec'
require 'logger'

describe Baidu::Push::AsyncClient do

  subject { Baidu::Push::AsyncClient.setup(api_key: '',
                                           secret_key: '',
                                           logger: Logger.new(STDOUT)) }

  context 'push message' do
    it 'should push a message, async' do
      msg = Baidu::Push::Message.new msg_keys: "#{Time.now.to_i}_test",
                                     user_id: '',
                                     message_type: 1
      msg.messages = {title: 'test', description: 'test', custom_content: {}}
      res = subject.future.push_msg(msg)
      expect(res.value.status).to eql 200
    end
  end

end