require 'spec_helper'

describe RubyShift::Client do
	it { should respond_to :applications }

	describe ".applications" do
		before do
			stub_get("/applications", "applications")
			@applications = RubyShift.applications
		end		

		it "should get the correct resource" do
			expect(a_get("/applications")).to have_been_made
		end

		it "should return a list of applications" do
			expect(@applications).to be_an Array
			expect(@applications.first.name).to eq("hamlet")
			expect(@applications.first.domain_id).to eq("rubyshift")
			expect(@applications.first.framework).to eq("python-3.3")			
		end
	end

	describe ".application" do
		before do
			stub_get("/application/5714ae1189f5cf026b00002f", "application")
			@application = RubyShift.application("5714ae1189f5cf026b00002f")
		end

		it "should get the correct resource" do
			expect(a_get("/application/5714ae1189f5cf026b00002f")).to have_been_made
		end

		it "should return application info json" do
			expect(@application.name).to eq("othello")
			expect(@application.domain_id).to eq("rubyshift")
			expect(@application.framework).to eq("ruby-2.0")
		end
	end
end
