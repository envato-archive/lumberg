require 'spec_helper'
require 'lumberg/whm'

module Lumberg
  describe Whm::Base do
    before(:each) do
      @login    = { :host => @whm_host, :hash => @whm_hash }
      @server   = Whm::Server.new(@login.dup)
      @base = Whm::Base.new(:server => @server)
    end

    describe "#initialize" do
      it "creates a new instance of server" do
        expect { Whm::Base.new }.to raise_error(WhmArgumentError, /Missing required param/)
      end

      it "allows a server instance to be passed in" do
        @base.server.should be_a(Whm::Server)
      end

      it "allows a server hash to be passed in" do
        base = Whm::Base.new(:server => @login)
        base.server.should be_a(Whm::Server)
      end
    end

    describe "#account" do
      it "has an account accessor" do
        @base.account.should be_an(Whm::Account)
      end

    end

    describe "#dns" do
      it "has an dns accessor" do
        @base.dns.should be_an(Whm::Dns)
      end
    end

    describe "#reseller" do
      it "has an reseller accessor" do
        @base.reseller.should be_an(Whm::Reseller)
      end
    end

    describe "#method_missing" do
      it "caches @vars" do
        Whm.should_receive(:const_get).once.and_return(Whm::Account)
        @base.account
        @base.account
      end
      
      it "raises to super" do
        expect { @base.asdf }.to raise_error(NoMethodError)
      end
    end
  end
end
