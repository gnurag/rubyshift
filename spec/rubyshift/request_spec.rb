require 'spec_helper'

describe RubyShift::Request do
	it { should respond_to :get}
	it { should respond_to :post}
	it { should respond_to :put}
	it { should respond_to :delete}

	before do
		@request = RubyShift::Request.new
	end

	describe ".default_options" do
		it "should have default values set" do
			default_options = RubyShift::Request.default_options
			expect(default_options).to be_a Hash
			expect(default_options[:parser]).to be_a Proc
			expect(default_options[:format]).to eq(:json)
			expect(default_options[:headers]).to eq({'Accept' => 'application/json'})
			expect(default_options[:default_params]).to be_nil
		end
	end

	describe ".parse" do
		it "should return OpenStruct object" do
			body = JSON.unparse(a: 1, b: 2)
			expect(RubyShift::Request.parse(body)).to be_an OpenStruct
			expect(RubyShift::Request.parse("true")).to be true
			expect(RubyShift::Request.parse("false")).to be false

			expect { RubyShift::Request.parse("test string") }.to raise_error(RubyShift::Error::Parsing)
		end
	end

	describe "#set_request_defaults" do
		context "when endpoint is not set" do
			it "should raise Error::MissingCredentials" do
				@request.endpoint = nil
				expect do
					@request.set_request_defaults
				end.to raise_error(RubyShift::Error::MissingCredentials, 'Please set an API endpoint')
			end
		end

		context "when endpoint is set" do
			before(:each) do
				@request.endpoint = 'http://openshift_spec.redhat.com/broker/rest'
			end

			it "should allow setting default_params" do
				@request.set_request_defaults
				expect(RubyShift::Request.default_params).to eq(httparty: {})
			end
		end
	end

	describe "#set_authorization_header" do
		it "should raise MissingCredentials when access_token is not set" do
			expect do
				@request.send(:set_authorization_header, {})
			end.to raise_error(RubyShift::Error::MissingCredentials)
		end

		it "should set Authorization header when access_token is provided" do
			@request.access_token = 'Z5b5IhP1a0whYv5o6JyWcvj6WgZFbgDD3W7rZDCWMdacffBn5ZybTxtZXEFVYFUg'
			expect(@request.send(:set_authorization_header, {})).to eq("Authorization" => "Bearer Z5b5IhP1a0whYv5o6JyWcvj6WgZFbgDD3W7rZDCWMdacffBn5ZybTxtZXEFVYFUg")
		end
	end

	describe "#handle_error" do
		before do
			@array = ['First message.', 'Second message.']
			@obj   = OpenStruct.new(firstkey: ['not set'], secondkey: ['x'], nested_key: { foo: ['bar'], baz: 'bleh' })
		end

		context "when passed an OpenStruct" do
		end

		context "when passed an Array" do
			it "should return a concatenated string of messages" do
				expect(@request.send(:handle_error, @array)).to eq('First message. Second message.')
			end
		end

		context "when passed a string" do
			it "should return the string untouched" do
				error = 'here be error string'
				expect(@request.send(:handle_error, error)).to eq('here be error string')
			end
		end
	end
end