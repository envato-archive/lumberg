#$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'rspec'
require 'fakeweb'
require 'lumberg'

# Fake requests gonna fake request
Spec::Runner.configure do |config|
  config.before(:each) do
    FakeWeb.allow_net_connect = false
    FakeWeb.clean_registry
  end
end
