require 'net/https'
require 'uri'
require 'json'

module Txtlocal
  class Message

    attr_accessor :body
    attr_accessor :recipients
    attr_accessor :from

    attr_accessor :response

    def initialize(message=nil, recipients=nil, options=nil)
      self.body = message if message
      self.recipients = recipients if recipients
      self.options = options if options
    end

    def body=(body)
      @body = body.strip.gsub(/\n/, '%n')
    end

    def recipients
      @recipients ||= []
    end
    def recipients=(recipients)
      @recipients = []
      [*recipients].each do |recip|
        add_recipient(recip)
      end
    end
    def add_recipient(recipient)
      recipient = recipient.gsub(/\s/, '')
      recipient = case recipient
        when /^447\d{9}$/
          recipient
        when /^(?:\+447|07)(\d{9})$/
          "447#{$1}"
        else
          return
      end
      recipients << recipient
    end

    def from
      self.from = Txtlocal.config.from if not @from
      @from
    end
    def from=(from)
      if from.to_s.length < 3
        @from = nil
      else
        @from = from.strip.gsub(/[^\w ]/, '').to_s[0, 11]
      end
    end

    def options=(options)
      self.from = options[:from] if options.has_key?(:from)
    end

    def response=(response)
      if not response.body.empty?
        @response = {}
        data = JSON.parse(response.body)
        data.each_pair do |k, v|
          key = k.gsub(/\B[A-Z]+/, '_\0').downcase.to_sym
          @response[key] = v
        end
      end
    end

    API_ENDPOINT = URI.parse("https://www.txtlocal.com/sendsmspost.php")
    def send!
      http = Net::HTTP.new(API_ENDPOINT.host, API_ENDPOINT.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      req = Net::HTTP::Post.new(API_ENDPOINT.path)
      req.set_form_data(:json => 1,
                        :test => Txtlocal.config.testing? ? 1 : 0,
                        :from => from,
                        :message => body,
                        :selectednums => recipients.join(","),
                        :uname => Txtlocal.config.username,
                        :pword => Txtlocal.config.password)
      result = http.start { |http| http.request(req) }
      self.response = result
    end
  end
end
