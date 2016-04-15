module RubyShift
  class Client < API
    Dir[File.expand_path('../client/*.rb', __FILE__)].each { |f| require f }

    include Applications
    include Domains
    include Cartridges
  end
end
