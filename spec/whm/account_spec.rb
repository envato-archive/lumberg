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
        expect { @account.createacct}.to raise_error(WhmArgumentError, /Missing required parameter: username/)
      end

      it "should require a domain" do
        expect { @account.createacct(username: 'user')}.to raise_error(WhmArgumentError, /Missing required parameter: domain/)
      end

      it "should require a password" do
        expect { @account.createacct(username: 'user', domain: 'example.com')}.to raise_error(WhmArgumentError, /Missing required parameter: password/)
      end

      it "should create the account with proper params" do
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

      it "should return an error on duplicate accounts" do
        @account.createacct(username: 'invalid', password: 'hummingbird123', domain: 'invalid-thing.com')
        message = @account.createacct(username: 'invalid', password: 'hummingbird123', domain: 'invalid-thing.com')
        message[:success].should be(false)
        message[:message].should match(/username already exists/i)
      end
    end

    describe "removeacct" do
      use_vcr_cassette "whm/account/removeacct"
      it "should require a 'user' param" do
        expect { @account.removeacct }.to raise_error(WhmArgumentError, /Missing required parameter: user/)
      end

      it "should remove a user and keep DNS by default" do
        message = @account.removeacct(user: 'removeme')
        message[:success].should be(true)
        message[:params][:rawout].should match(/Removing DNS Entries/i)
      end

      it "should remove a user and remove DNS when asked" do
        message = @account.removeacct(user: 'removeme', keepdns: 0)
        message[:success].should be(true)
        message[:params][:rawout].should match(/Removing DNS Entries/i)
      end

      it "should remove a user but keep DNS" do
        message = @account.removeacct(user: 'removeme', keepdns: 1)
        message[:success].should be(true)
        message[:params][:rawout].should_not match(/Removing DNS Entries/i)
      end

      it "should return an error when the user doesn't exist" do
        message = @account.removeacct(user: 'notreal')
        message[:success].should be(false)
        message[:message].should match(/notreal does not exist/i)
      end
    end
  end
end
