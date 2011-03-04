require 'spec_helper'
require 'lumberg/whm'

module Lumberg
  describe Whm::Dns do
    before(:each) do
      @login    = { :host => @whm_host, :hash => @whm_hash }
      @server   = Whm::Server.new(@login.dup)
      @dns      = Whm::Dns.new(:server => @server.dup)
    end

    context "new" do
      it "requires a server" do
        expect { Whm::Dns.new }.to raise_error(WhmArgumentError, /Missing.*: server/) 
      end

      it "sets up a server" do
        @dns = Whm::Dns.new(:server => @server.dup)
        @dns.server.should be_a(Whm::Server)
      end
    end

    context "add_zone" do
      it "requires a domain" do
        @dns.stub(:perform_request)
        expect { @dns.add_zone }.to raise_error(WhmArgumentError, /Missing.*: domain/) 
      end

      it "requires an ip" do
        expect { @dns.add_zone(:domain => 'example.com') }.to raise_error(WhmArgumentError, /Missing.*: ip/) 
      end

      it "allows template" do
        @dns.server.stub(:perform_request)
        @dns.add_zone(:domain => 'example.com', :ip => '127.0.0.1', :template => 'something')
      end

      it "allows trueowner" do
        @dns.server.stub(:perform_request)
        @dns.add_zone(:domain => 'example.com', :ip => '127.0.0.1', :trueowner => 'something')
      end

      use_vcr_cassette "whm/account/adddns"

      it "creates a zone" do
        result = @dns.add_zone(:domain => 'example.com', :ip => '127.0.0.1')
        result[:success].should be_true
        result[:message].should match(/added example\.com .*user root.*/i)
      end

      it "creates a zone under a user" do
        result = @dns.add_zone(:domain => 'example.com', :ip => '127.0.0.1', :trueowner => 'something')
        result[:success].should be_true
        result[:message].should match(/added example\.com .*user something.*/i)
      end
    end

    context "add zone record", :wip => true do
      it "requires a zone" do
        expect { @dns.add_zone_record() }.to raise_error(WhmArgumentError, /Missing.*: zone/)
      end

      use_vcr_cassette "whm/account/addzonerecord"

      it "adds a zone record" do
        pending "script is giving an error"
        result = @dns.add_zone_record(:zone => 'example.com', 
                                      :address => '127.0.0.1',
                                      :type => 'A')
        result[:success].should be_true
        result[:message].should match(/Bind reloading on host.*example.com/i)
      end
    end


  end
end
