module RubyShift

  class API < Request
    attr_accessor(*Configuration::VALID_OPTIONS_KEYS)
    
    # Creates a new API.
    # @raise [Error:MissingCredentials]
    def initialize(options={})
      options = RubyShift.options.merge(options)
      (Configuration::VALID_OPTIONS_KEYS + [:access_token]).each do |key|
        send("#{key}=", options[key]) if options[key]
      end
      set_request_defaults
    end
  end
end
