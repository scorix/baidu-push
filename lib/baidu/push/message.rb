# encoding: utf-8
require 'virtus'

module Baidu
  module Push
    class Message

      include Virtus.model

      # required
      # 方法名
      attribute :method, String

      # required
      # 访问令牌，明文AK，可从此值获得App的信息，配合sign中的sk做合法性身份认证。
      attribute :apikey, String

      # required, but don't set here
      # 调用参数签名值，与apikey成对出现。
      # 详细用法，请参考：[签名计算算法](http://developer.baidu.com/wiki/index.php?title=docs/cplat/push/api#.E7.AD.BE.E5.90.8D.E7.AE.97.E6.B3.95)
      # attribute :sign, String

      # required
      # 推送类型，取值范围为：1～3
      #   1：单个人，必须指定user_id 和 channel_id （指定用户的指定设备）或者user_id（指定用户的所有设备）
      #   2：一群人，必须指定 tag
      #   3：所有人，无需指定tag、user_id、channel_id
      attribute :push_type, Integer, default: ->(_, _) { 1 }

      # required
      # 用户发起请求时的unix时间戳。本次请求签名的有效时间为该时间戳+10分钟。
      attribute :timestamp, Integer, default: ->(_, _) { Time.now.to_i }

      # required
      # 指定消息内容，单个消息为单独字符串。如果有二进制的消息内容，请先做 BASE64 的编码。
      # 当message_type为1 （通知类型），请按以下格式指定消息内容。
      # 通知消息格式及默认值：
      #
      #    {
      #        //android必选，ios可选
      #        "title" : "hello" ,
      #        “description: "hello world"
      #
      #        //android特有字段，可选
      #        "notification_builder_id": 0,
      #        "notification_basic_style": 7,
      #        "open_type":0,
      #        "net_support" : 1,
      #        "user_confirm": 0,
      #        "url": "http://developer.baidu.com",
      #        "pkg_content":"",
      #        "pkg_name" : "com.baidu.bccsclient",
      #        "pkg_version":"0.1",
      #
      #        //android自定义字段
      #        "custom_content": {
      #            "key1":"value1",
      #            "key2":"value2"
      #        },
      #
      #        //ios特有字段，可选
      #        "aps": {
      #            "alert":"Message From Baidu Push",
      #            "sound":"",
      #            "badge":0
      #        },
      #
      #        //ios的自定义字段
      #        "key1":"value1",
      #            "key2":"value2"
      #        }
      #    注意：
      #
      #    当description与alert同时存在时，ios推送以alert内容作为通知内容
      #    当custom_content与 ios的自定义字段"key" ："value"同时存在时，ios推送的自定义字段内容会将以上两个内容合并，但推送内容整体长度不能大于256B，否则有被截断的风险。
      #    此格式兼容Android和ios原生通知格式的推送。
      #    如果通过Server SDK推送成功，Android端却收不到通知，解决方案请参考该：问题
      attribute :messages, String

      # required
      # 消息标识。
      # 指定消息标识，必须和messages一一对应。相同消息标识的消息会自动覆盖。特别提醒：该功能只支持android、browser、pc三种设备类型。
      attribute :msg_keys, String

      # optional
      # 用户标识，在Android里，channel_id + userid指定某一个特定client。不超过256字节，如果存在此字段，则只推送给此用户。
      attribute :user_id, String

      # optional
      # 通道标识
      attribute :channel_id, Integer

      # optional
      # 标签名称，不超过128字节
      attribute :tag, String

      # optional
      # 设备类型，取值范围为：1～5
      # 云推送支持多种设备，各种设备的类型编号如下：
      #   1：浏览器设备；
      #   2：PC设备；
      #   3：Android设备；(default)
      #   4：iOS设备；
      #   5：Windows Phone设备；
      attribute :device_type, Integer, default: ->(_, _) { 3 }

      # optional
      # 消息类型
      #   0：消息（透传给应用的消息体）(default)
      #   1：通知（对应设备上的消息通知）
      attribute :message_type, Integer, default: ->(_, _) { 0 }

      # optional
      # 指定消息的过期时间，默认为 86400 秒。必须和messages一一对应。
      attribute :message_expires, Integer, default: ->(_, _) { 86400 }

      # optional
      # 部署状态。指定应用当前的部署状态，可取值：
      #   1：开发状态 (default for the gem)
      #   2：生产状态 (default at baidu)
      # Notice: ios only
      attribute :deploy_status, Integer, default: ->(_, _) { 1 }

      # optional
      # 用户指定本次请求签名的失效时间。格式为unix时间戳形式。
      attribute :expires, Integer

      # optional
      # API版本号，默认使用最高版本。
      attribute :v, Integer

      def non_nil_attributes
        attributes.reject { |_, v| v.nil? }
      end

      def messages=(msg = {})
        message = {}
        message[:title] = msg[:title].to_s
        case device_type
          when 3
            message[:description] = msg[:description].to_s
            message[:custom_content] = msg[:custom_content]
          when 4
            message[:aps] = msg[:aps]
            msg[:custom_content].each { |k, v| message[k] = v }
        end
        super(message.to_json)
      end

    end
  end
end