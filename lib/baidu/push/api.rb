require 'faraday'

module Baidu
  module Push
    class API
      attr_reader :connection

      def initialize(options = {})
        @connection = Faraday.new(url: default_domain) do |faraday|
          faraday.request :multipart
          faraday.request :url_encoded
          faraday.response :logger, options[:logger] if options[:logger]
          faraday.adapter Faraday.default_adapter
        end
      end

      def base_path
        '/rest/2.0/channel'
      end

      def default_domain
        'https://channel.api.duapp.com'
      end

    end
  end
end
