module Baidu
  module Push

    class Client
      attr_accessor :config, :logger

      def self.setup(options = {api_key: nil, secret_key: nil})
        raise 'api_key can not be nil.' unless options[:api_key]
        raise 'secret_key can not be nil.' unless options[:secret_key]
        md5 = Digest::MD5.hexdigest([options[:api_key], options[:secret_key]].join)
        instance_variable_get("@client_#{md5}") ||
            instance_variable_set("@client_#{md5}", begin
                                                    config = Configuration.new
                                                    config.api_key = options[:api_key]
                                                    config.secret_key = options[:secret_key]
                                                    client = self.new
                                                    client.config = config
                                                    client.logger = options[:logger]
                                                    client
                                                  end)
      end

      def rest_api
        @api ||= API.new(logger: logger)
      end

      def push_msg(message)
        raise 'invalid baidu push message' unless message.is_a?(Baidu::Push::Message)
        attr = message.non_nil_attributes
        attr.merge!(apikey: config.api_key, method: __method__)
        rest_api.connection.post do |req|
          req.url "#{rest_api.base_path}/channel"
          req.params = attr.merge(sign: get_sign('POST', "#{rest_api.default_domain}#{rest_api.base_path}/channel", attr))
        end
      end

      private
      def get_sign(http_method, url, params)
        es = [http_method.to_s.upcase, url, params.sort.map { |x| "#{x[0]}=#{x[1]}" }, config.secret_key]
        Digest::MD5.hexdigest(CGI.escape(es.flatten.join))
      end
    end
  end
end
