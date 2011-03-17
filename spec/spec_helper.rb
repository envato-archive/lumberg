#$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'rspec'
require 'lumberg'
require 'lumberg/exceptions'
require 'vcr'
require 'timeout'

VCR.config do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.stub_with :fakeweb
  c.default_cassette_options = {:record => :new_episodes}
end

def live_test?
  !ENV['WHM_REAL'].nil?
end

def requires_attr(attr, &block)
  expect { block.call }.to raise_error(Lumberg::WhmArgumentError, /Missing required parameter: #{attr}/i)
end

RSpec.configure do |c|
  c.extend VCR::RSpec::Macros
  c.before(:each) do
    if live_test?
      @whm_hash = ENV['WHM_HASH'].dup
      @whm_host = ENV['WHM_HOST'].dup
    else
      @whm_hash = 'iscool'
      @whm_host = 'myhost.com'
    end
  end
end
