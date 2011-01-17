require 'txtlocal/config'
require 'txtlocal/message'

module Txtlocal
  class << self
    def config
      @config ||= Config.new
      if block_given?
        yield @config
      end
      @config
    end

    def send_message(message, recipients, options={})
      msg = Txtlocal::Message.new(message, recipients, options)
      msg.send!
      msg
    end
  end
end

