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
      use_vcr_cassette "whm/account/createacct"

      it "should require a username" do
        expect { @account.createacct}.to raise_error(WhmArgumentError, /Missing required param.* username/)
      end

      it "should require a domain" do
        expect { @account.createacct(username: 'user')}.to raise_error(WhmArgumentError, /Missing required param.* domain/)
      end

      it "should require a password" do
        expect { @account.createacct(username: 'user', domain: 'example.com')}.to raise_error(WhmArgumentError, /Missing required param.* password/)
      end

      it "should allow account creation with proper params" do
        message = @account.createacct(username: 'valid', password: 'hummingbird123', domain: 'valid-thing.com')
        message[:success].should be(true)
        message[:message].should match(/Account Creation Ok/i)
        message[:params].should_not be_empty
        message[:params].should have_key(:options)
        message[:params][:options].should include(:nameserver4, :nameserver, :nameserverentry2, :nameserverentry3, 
                                                  :nameserverentry4, :nameserverentry, :ip, :nameservera2, 
                                                  :nameservera3, :package, :nameservera4, :nameserver2, 
                                                  :nameservera, :nameserver3)
      end

      it "should return an error on duplicate account" do
        @account.createacct(username: 'invalid', password: 'hummingbird123', domain: 'invalid-thing.com')
        message = @account.createacct(username: 'invalid', password: 'hummingbird123', domain: 'invalid-thing.com')
        message[:success].should be(false)
        message[:message].should match(/username already exists/i)
      end
    end
  end
end
