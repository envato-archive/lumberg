require 'spec_helper'
require 'lumberg/whm'
require 'lumberg/cpanel'

module Lumberg
  describe Cpanel::Base do
    before(:each) do
      # TODO: DRY (also in whm/base_spec.rb)
      @login  = { :host => @whm_host, :hash => @whm_hash }
      @server = Whm::Server.new(@login.dup)
      @base   = Whm::Base.new(:server => @server)
    end

    describe "#initialize" do
    end
  end
end
