require 'celluloid'

module Baidu
  module Push

    class Client
      attr_accessor :config, :logger

      include Celluloid

      def self.setup(options = {api_key: nil, secret_key: nil})
        raise 'api_key can not be nil.' unless options[:api_key]
        raise 'secret_key can not be nil.' unless options[:secret_key]
        config = Configuration.new
        config.api_key = options[:api_key]
        config.secret_key = options[:secret_key]
        client = self.new
        client.config = config
        client.logger = options[:logger]
        client
      end

      def push_msg(message)
        raise 'invalid baidu push message' unless message.is_a?(Baidu::Push::Message)
        attr = message.non_nil_attributes
        api = API.new(logger: logger)
        api.connection.post do |req|
          req.url "#{api.base_path}/channel"
          req.params = attr.merge(sign: get_sign('POST', "#{api.default_domain}#{api.base_path}/channel", attr))
          req.options.timeout = 5 # open/read timeout in seconds
          req.options.open_timeout = 2 # connection open timeout in seconds
        end
      end

      private
      def get_sign(http_method, url, params)
        es = [http_method.to_s.upcase, url, params.sort.map { |x| "#{x[0]}=#{x[1]}" }, @config.secret_key]
        Digest::MD5.hexdigest(CGI.escape(es.flatten.join))
      end
    end
  end
end
