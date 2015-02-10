# Baidu::Push::Client

A simple REST client for [baidu push](http://developer.baidu.com/wiki/index.php?title=docs/cplat/push/api/list)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'baidu-push', github: 'scorix/baidu-push'
```

And then execute:

    $ bundle

## Usage

```ruby
# build a baidu message
msg = Baidu::Push::Message.new msg_keys: "#{Time.now.to_i}_test", user_id: 'userid'
msg.messages = {title: 'test', description: 'test', custom_content: {}}

# new a client instance
client = Baidu::Push::Client.setup api_key: 'YOUR_API_KEY', secret_key: 'YOUR_SECRET_KEY'
client.push_msg(msg)
```

Or, you can also push the message with an async way

```ruby
# build a baidu message
msg = Baidu::Push::Message.new msg_keys: "#{Time.now.to_i}_test", user_id: 'userid'
msg.messages = {title: 'test', description: 'test', custom_content: {}}

# new a client instance
client = Baidu::Push::AsyncClient.setup api_key: 'YOUR_API_KEY', secret_key: 'YOUR_SECRET_KEY'
client.async.push_msg(msg)
```

## Contributing

1. Fork it ( https://github.com/scorix/baidu-push/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
