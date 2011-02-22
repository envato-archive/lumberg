require 'spec_helper'
require 'lumberg/whm'

module Lumberg
  describe Whm::Account do
    before(:each) do
      @login    = { host: @whm_host, hash: @whm_hash }
      @server   = Whm::Server.new(@login.dup)
      @account  = Whm::Account.new(server: @server.dup)
    end

    describe "initialize" do
      it "should create a new instance of server" do
        expect { Whm::Account.new }.to raise_error(WhmArgumentError, /Missing required param/)
      end

      it "should allow a server instance to be passed in" do
        account = Whm::Account.new(server: @server)
        account.server.should be_a(Whm::Server)
      end

      it "should allow a server hash to be passed in" do
        account = Whm::Account.new(server: @login)
        account.server.should be_a(Whm::Server)
      end
    end

    describe "createacct" do

      it "should require a username" do
        expect { @account.createacct}.to raise_error(WhmArgumentError, /Missing required param.* username/)
      end

      it "should require a domain" do
        expect { @account.createacct(username: 'user')}.to raise_error(WhmArgumentError, /Missing required param.* domain/)
      end

      it "should require a password" do
        expect { @account.createacct(username: 'user', domain: 'example.com')}.to raise_error(WhmArgumentError, /Missing required param.* password/)
      end

      use_vcr_cassette "whm/account/createacct"

      it "should allow account creation" do
        message = @account.createacct(username: 'validu', password: 'hummingbird123', domain: 'valid-thing.com')
        message[:success].should be(true)
        message[:message].should match(/Account Creation Ok/i)
      end

    end
  end
end
