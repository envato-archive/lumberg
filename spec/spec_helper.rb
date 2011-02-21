#$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'rspec'
require 'lumberg'
require 'vcr'

VCR.config do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.stub_with :fakeweb
end

RSpec.configure do |c|
  c.extend VCR::RSpec::Macros
end
