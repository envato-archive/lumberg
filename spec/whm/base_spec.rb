require 'spec_helper'
require 'lumberg/whm'

module Lumberg
  describe Whm::Base do
    before(:each) do
      @login    = { host: @whm_host, hash: @whm_hash }
      @server   = Whm::Server.new(@login.dup)
      @base = Whm::Base.new(server: @server)
    end

    describe "#initialize" do
      it "allows a server instance to be passed in" do
        @base.server.should be_a(Whm::Server)
      end

      it "allows a server hash to be passed in" do
        base = Whm::Base.new(server: @login)
        base.server.should be_a(Whm::Server)
      end
    end

  end
end
