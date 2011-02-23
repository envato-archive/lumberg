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

    describe "create" do
      use_vcr_cassette "whm/account/createacct"

      it "should require a username" do
        expect { @account.create}.to raise_error(WhmArgumentError, /Missing required parameter: username/)
      end

      it "should require a domain" do
        expect { @account.create(username: 'user')}.to raise_error(WhmArgumentError, /Missing required parameter: domain/)
      end

      it "should require a password" do
        expect { @account.create(username: 'user', domain: 'example.com')}.to raise_error(WhmArgumentError, /Missing required parameter: password/)
      end

      it "should create the account with proper params" do
        message = @account.create(username: 'valid', password: 'hummingbird123', domain: 'valid-thing.com')
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
        @account.create(username: 'invalid', password: 'hummingbird123', domain: 'invalid-thing.com')
        message = @account.create(username: 'invalid', password: 'hummingbird123', domain: 'invalid-thing.com')
        message[:success].should be(false)
        message[:message].should match(/username already exists/i)
      end
    end

    describe "remove" do
      use_vcr_cassette "whm/account/removeacct"

      it "should require a 'username' param" do
        expect { @account.remove }.to raise_error(WhmArgumentError, /Missing required parameter: username/)
      end

      it "should remove a user and keep DNS by default" do
        message = @account.remove(username: 'removeme')
        message[:success].should be(true)
        message[:params][:rawout].should match(/Removing DNS Entries/i)
      end

      it "should remove a user and remove DNS when asked" do
        message = @account.remove(username: 'removeme', keepdns: 0)
        message[:success].should be(true)
        message[:params][:rawout].should match(/Removing DNS Entries/i)
      end

      it "should remove a user but keep DNS" do
        message = @account.remove(username: 'removeme', keepdns: 1)
        message[:success].should be(true)
        message[:params][:rawout].should_not match(/Removing DNS Entries/i)
      end

      it "should return an error when the user doesn't exist" do
        message = @account.remove(username: 'notreal')
        message[:success].should be(false)
        message[:message].should match(/notreal does not exist/i)
      end
    end

    describe "change_password" do
      use_vcr_cassette "whm/account/passwd"

      it "should require a user" do
        expect { @account.change_password }.to raise_error(WhmArgumentError, /Missing required parameter: username/)
      end

      it "should require a password" do
        expect { @account.change_password(username: 'changeme') }.to raise_error(WhmArgumentError, /Missing required parameter: pass/)
      end

      it "should change the password" do
        message = @account.change_password(username: 'changeme', pass: 'superpass')
        message[:success].should be(true)
        message[:message].should match(/Password changed for user changeme/i)
      end

      it "should not be successful when the user doesn't exist" do
        message = @account.change_password(username: 'dontchangeme', pass: 'superpass')
        message[:success].should be(false)
        message[:message].should match(/dontchangeme does not exist/i)
      end
    end

    describe "limit bandwidth" do
      pending
    end 

    describe "list" do
      pending
    end 

    describe "modify" do
      pending
    end 

    describe "editquota" do
      pending
    end 

    describe "summary" do
      use_vcr_cassette "whm/account/accountsummary"
      it "should require a user" do
        expect { @account.summary }.to raise_error(WhmArgumentError, /Missing required parameter: username/i)
      end

      it "should return an error for invalid users" do
        result = @account.summary(username: 'notexists')
        result[:success].should_not be_true
        result[:message].should match(/does not exist/i)
      end

      it "should return a summary" do
        result = @account.summary(username: 'summary')
        result[:success].should be_true
        result[:message].should match(/ok/i)
      end
    end 

    describe "suspend" do
      pending
    end 

    describe "unsuspend" do
      pending
    end 

    describe "list suspended" do
      pending
    end 

    describe "remove" do
      pending
    end 

    describe "change package" do
      pending
    end 

    describe "privs" do
      pending
    end 

    describe "domainuserdata" do
      pending
    end 

    describe "setsiteip" do
      pending
    end 

    describe "restore" do
      # 11.27/11.28+ only
      pending
    end 
  end
end
