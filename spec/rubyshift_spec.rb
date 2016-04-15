require 'spec_helper'

describe RubyShift do
	after { RubyShift.reset }
	
	describe ".client" do
		it "should be RubyShift::Client" do
			expect(RubyShift.client).to be_a RubyShift::Client
		end

		it "should not override other RubyShift::Client objects" do
			client1 = RubyShift.client(endpoint: 'https://openshift1.example.com', access_token: 'hunter1')
			client2 = RubyShift.client(endpoint: 'https://openshift2.example.com', access_token: 'hunter2')
			expect(client1.endpoint).to eq('https://openshift1.example.com')
			expect(client2.endpoint).to eq('https://openshift2.example.com')
			expect(client1.access_token).to eq('hunter1')
			expect(client2.access_token).to eq('hunter2')
		end
	end

	describe ".actions" do
		it "should return an array of client methods" do
			actions = RubyShift.actions
			expect(actions).to be_an Array
			expect(actions.first).to be_a Symbol
			expect(actions.sort.first).to eq(:application)
		end
	end

	describe ".endpoint=" do
		it "should set endpoint" do
			RubyShift.endpoint = 'https://openshift.example.com'
			expect(RubyShift.endpoint).to eq('https://openshift.example.com')
		end
	end

	describe ".username=" do
		it "should set username" do
			RubyShift.username = 'openshiftuser@example.com'
			expect(RubyShift.username).to eq('openshiftuser@example.com')
		end
	end

	describe ".password=" do
		it "should set password" do
			RubyShift.password = 'hunter2'
			expect(RubyShift.password).to eq('hunter2')
		end
	end

	describe ".access_token=" do
		it "should set access_token" do
			RubyShift.access_token = 'hunter2hunter2hunter2'
			expect(RubyShift.access_token).to eq('hunter2hunter2hunter2')
		end
	end

	describe ".user_agent" do
		it "should return default user_agent" do
			expect(RubyShift.user_agent).to eq(RubyShift::Configuration::DEFAULT_USER_AGENT)
		end
	end

	describe ".user_agent=" do
		it "should set access_token" do
			RubyShift.user_agent = 'CustomUserAgent/1.1'
			expect(RubyShift.user_agent).to eq('CustomUserAgent/1.1')
		end
	end

	describe ".configure" do
		RubyShift::Configuration::VALID_OPTIONS_KEYS.each do |key|
			it "should set #{key}" do
				RubyShift.configure do |config|
					config.send("#{key}=", key)
					expect(RubyShift.send(key)).to eq(key)
				end
			end
		end
	end

	describe ".http_proxy" do
		it "delegates the method to RubyShift::Request" do
			RubyShift.endpoint = 'https://openshift.example.com'
			request = class_spy(RubyShift::Request).as_stubbed_const

			RubyShift.http_proxy('proxy.example.net', 1337, 'proxyuser', 'hunter2')
			expect(request).to have_received(:http_proxy).
			with('proxy.example.net', 1337, 'proxyuser', 'hunter2')
		end
	end
end
