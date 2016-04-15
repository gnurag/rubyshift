require 'rubyshift/version'
require 'rubyshift/configuration'
require 'rubyshift/error'
require 'rubyshift/request'
require 'rubyshift/api'
require 'rubyshift/client'

module RubyShift
  extend Configuration

  def self.client(options={})
    RubyShift::Client.new(options)
  end

  # Delegate to RubyShift::Client
  def self.method_missing(method, *args, &block)
    return super unless client.respond_to?(method)
    client.send(method, *args, &block)
  end

  def respond_to_missing?(method_name, include_private = false)
    client.respond_to?(method_name) || super
  end

  # Delegate to HTTParty.http_proxy
  def self.http_proxy(address=nil, port=nil, username=nil, password=nil)
    RubyShift::Request.http_proxy(address, port, username, password)
  end

  # Return an array of available client methods
  def self.actions
    hidden = /endpoint|username|password|access_token|user_agent|get|post|put|\Adelete\z|validate|set_request_defaults|httparty/
    (RubyShift::Client.instance_methods - Object.methods).reject { |e| e[hidden]}
  end
end
