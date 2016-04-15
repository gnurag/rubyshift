require 'httparty'
require 'json'
require 'ostruct'

module RubyShift
  class Request
    include HTTParty
    format :json
    headers 'Accept' => 'application/json'
    parser proc { |body, _| parse(body) }

    attr_accessor :access_token, :endpoint

    def self.parse(body)
      data = decode(body)['data']

      if data.is_a? Hash
        data.delete('links')
        data.delete('members')
        OpenStruct.new data
      elsif data.is_a? Array
        data.collect! { |d|
          d.delete('links')
          d.delete('members')
          OpenStruct.new(d)
        }
      elsif data
        true
      elsif !data
        false
      elsif data.nil?
        false
      else
        raise Error::Parsing.new "Couldn't parse the response body: #{body.inspect}" 
      end
    rescue
      raise Error::Parsing.new "Couldn't parse the response body: #{body.inspect}"
    end

    def self.decode(response)
      JSON.load response
    rescue JSON::ParserError
      raise Error::Parsing.new "The response is not a valid JSON"      
    end

    def get(path, options={})
      set_httparty_config(options)
      set_authorization_header(options)
      validate self.class.get(@endpoint + path, options)
    end

    def post(path, options={})
      set_httparty_config(options)
      set_authorization_header(options, path)
      validate self.class.post(@endpoint + path, options)
    end

    def put(path, options={})
      set_httparty_config(options)
      set_authorization_header(options)
      validate self.class.put(@endpoint + path, options)
    end

    def delete(path, options={})
      set_httparty_config(options)
      set_authorization_header(options)
      validate self.class.delete(@endpoint + path, options)
    end
    
    # Checks the response code for common errors.
    # Returns parsed response for successful requests.
    def validate(response)
      case response.code
      when 400 then fail Error::BadRequest.new error_message(response)
      when 401 then fail Error::Unauthorized.new error_message(response)
      when 403 then fail Error::Forbidden.new error_message(response)
      when 404 then fail Error::NotFound.new error_message(response)
      when 405 then fail Error::MethodNotAllowed.new error_message(response)
      when 409 then fail Error::Conflict.new error_message(response)
      when 422 then fail Error::Unprocessable.new error_message(response)
      when 500 then fail Error::InternalServerError.new error_message(response)
      when 502 then fail Error::BadGateway.new error_message(response)
      when 503 then fail Error::ServiceUnavailable.new error_message(response)
      end

      parsed = response.parsed_response
      parsed.client = self if parsed.respond_to?(:client=)
      parsed.parse_headers!(response.headers) if parsed.respond_to?(:parse_headers!)
      parsed
    end

    # Sets default_params for requests.
    # @raise [Error::MissingCredentials] if endpoint not set.
    def set_request_defaults
      raise Error::MissingCredentials.new("Please set an endpoint to API") unless @endpoint
      # self.class.default_params foo: :bar
    end

    private

    # Sets Authorization header for requests.
    # @raise [Error::MissingCredentials] if access_token is not set.
    def set_authorization_header(options, path=nil)
      unless path and path.start_with? '/oauth'
        raise Error::MissingCredentials.new("Please provide an access_token") unless @access_token
        options[:headers] = { 'Authorization' => "Bearer #{@access_token}" }
      end
    end

    # Set HTTParty configuration
    # @see https://github.com/jnunemaker/httparty
    def set_httparty_config(options)
      options.merge!(httparty) if httparty
    end

    def error_message(response)
      parsed_response = response.parsed_response
      message = parsed_response

      "Server responded with code #{response.code}, message: " \
      "#{message}. " \
      "Request URI: #{response.request.base_uri}#{response.request.path}"
    end
    
  end
end
