# RubyShift

RubyShift is a Ruby client for [OpenShift's REST API](https://access.redhat.com/documentation/en-US/OpenShift_Online/2.0/html/REST_API_Guide/index.html)

## Installation

Installing from rubygems:

```sh
gem install rubyshift
```

Via Gemfile:

```ruby
gem 'rubyshift', github: 'gnurag/rubyshift'
```

## Usage

Configuration example:

```ruby
require 'rubyshift'
RubyShift.configure do |config|
  config.endpoint = 'https://openshift.redhat.com/broker/rest'
  config.access_token = '<secret-access-token>'
  # Optional config options
  config.httparty = { timeout: 90 }
end                                                        
```

Usage example:

```ruby
RubyShift.applications
# => []

RubyShift.application_create('myapp', domain_name: 'rubyshift', cartridges: 'ruby-2.0', scale: true, gear_size: 'small')
# => #<OpenStruct aliases=[], app_url="http://myapp-rubyshift.rhcloud.com/", auto_deploy=true, build_job_url=nil, building_app=nil, building_with=nil, creation_time="2016-04-13T21:00:01Z", deployment_branch="master", deployment_type="git", domain_id="rubyshift", embedded={"haproxy-1.4"=>{}}, framework="ruby-2.0", gear_count=1, gear_profile="small", git_url="ssh://500000000000000000000001@myapp-rubyshift.rhcloud.com/~/git/myapp.git/", ha=false, health_check_path="health", id="500000000000000000000001", initial_git_url=nil, keep_deployments=1, name="myapp", scalable=true, ssh_url="ssh://500000000000000000000001@myapp-rubyshift.rhcloud.com">

RubyShift.application('500000000000000000000001')
# => #<OpenStruct aliases=[], app_url="http://myapp-rubyshift.rhcloud.com/", auto_deploy=true, build_job_url=nil, building_app=nil, building_with=nil, creation_time="2016-04-13T21:00:01Z", deployment_branch="master", deployment_type="git", domain_id="rubyshift", embedded={"haproxy-1.4"=>{}}, framework="ruby-2.0", gear_count=1, gear_profile="small", git_url="ssh://500000000000000000000001@myapp-rubyshift.rhcloud.com/~/git/myapp.git/", ha=false, health_check_path="health", id="500000000000000000000001", initial_git_url=nil, keep_deployments=1, name="myapp", scalable=true, ssh_url="ssh://500000000000000000000001@myapp-rubyshift.rhcloud.com">

RubyShift.application_restart('500000000000000000000001')
# => #<OpenStruct aliases=[], app_url="http://myapp-rubyshift.rhcloud.com/", auto_deploy=true, build_job_url=nil, building_app=nil, building_with=nil, creation_time="2016-04-13T21:00:01Z", deployment_branch="master", deployment_type="git", domain_id="rubyshift", embedded={"haproxy-1.4"=>{}}, framework="ruby-2.0", gear_count=1, gear_profile="small", git_url="ssh://500000000000000000000001@myapp-rubyshift.rhcloud.com/~/git/myapp.git/", ha=false, health_check_path="health", id="500000000000000000000001", initial_git_url=nil, keep_deployments=1, name="myapp", scalable=true, ssh_url="ssh://500000000000000000000001@myapp-rubyshift.rhcloud.com">

RubyShift.application_delete('500000000000000000000001')
# => true
```

## Acknowledgement

RubyShift is based on the excellent [gitlab](https://github.com/NARKOZ/gitlab) gem. 
