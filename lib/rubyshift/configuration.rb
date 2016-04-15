require 'json'

module RubyShift
  module Configuration

    VALID_OPTIONS_KEYS = [:endpoint, :username, :password, :access_token, :user_agent, :httparty].freeze

    DEFAULT_ENDPOINT   = 'https://openshift.redhat.com/broker/rest'
    DEFAULT_USER_AGENT = "RubyShift/#{RubyShift::VERSION}".freeze

    attr_accessor(*VALID_OPTIONS_KEYS)

    def self.exetended(base)
      base.reset
    end

    def configure
      yield self
    end

    def options
      VALID_OPTIONS_KEYS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    def reset
      self.endpoint = ENV['RUBYSHIFT_ENDPOINT']
      self.username = ENV['RUBYSHIFT_USERNAME']
      self.password = ENV['RUBYSHIFT_PASSWORD']
      self.access_token = ENV['RUBYSHIFT_ACCESS_TOKEN']
      self.httparty = get_httparty_config(ENV['RUBYSHIFT_HTTPARTY_OPTIONS'])
      self.user_agent = DEFAULT_USER_AGENT
    end

    private

    def get_httparty_config(options)
      return options if options.nil?

      httparty = JSON.parse options
      raise ArgumentError, "HTTParty config should be a Hash." unless httparty.is_a? Hash
      symbolize_keys httparty
    end

    def symbolize_keys(hash)
      if hash.is_a?(Hash)
        hash = hash.each_with_object({}) do |(key, value), newhash|
          begin
            newhash[key.to_sym] = symbolize_keys(value)
          rescue NoMethodError
            raise "Error: cannot convert hash key to symbol: #{key}"
          end
        end
      end

      hash
    end
    
  end
end
