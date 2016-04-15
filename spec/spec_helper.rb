require 'rspec'
require 'webmock/rspec'

require File.expand_path('../../lib/rubyshift', __FILE__)

def capture_output
	out = StringIO.new
	$stdout = out
	$stderr = out
	yield
	$stdout = STDOUT
	$stderr = STDERR
	out.string
end

def load_fixture(name)
	File.new(File.dirname(__FILE__) + "/fixtures/#{name}.json")
end


RSpec.configure do |config|
	config.before(:all) do
		RubyShift.endpoint = 'https://openshift.example.com/broker/rest'
		RubyShift.access_token = 'hunter2'
	end
end

# GET 
def stub_get(path, fixture)
	stub_request(:get, "#{RubyShift.endpoint}#{path}").
	with(headers: { 'Authorization' => "Bearer #{RubyShift.access_token}" }).
	to_return(body: load_fixture(fixture))
end

def a_get(path)
	a_request(:get, "#{RubyShift.endpoint}#{path}").
	with(headers: { 'Authorization' => "Bearer #{RubyShift.access_token}" })
end
