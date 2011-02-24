require 'spec_helper'
require 'lumberg/whm'

module Lumberg
  describe Whm::Account do
    before(:each) do
      @login    = { :host => @whm_host, :hash => @whm_hash }
      @server   = Whm::Server.new(@login.dup)
      @account  = Whm::Account.new(:server => @server.dup)
    end

    describe "initialize" do
      it "should create a new instance of server" do
        expect { Whm::Account.new }.to raise_error(WhmArgumentError, /Missing required param/)
      end

      it "should allow a server instance to be passed in" do
        account = Whm::Account.new(:server => @server)
        account.server.should be_a(Whm::Server)
      end

      it "should allow a server hash to be passed in" do
        account = Whm::Account.new(:server => @login)
        account.server.should be_a(Whm::Server)
      end
    end

    describe "create" do
      use_vcr_cassette "whm/account/createacct"

      it "should require a username" do
        expect { @account.create}.to raise_error(WhmArgumentError, /Missing required parameter: username/)
      end

      it "should require a domain" do
        expect { @account.create(:username => 'user')}.to raise_error(WhmArgumentError, /Missing required parameter: domain/)
      end

      it "should require a password" do
        expect { @account.create(:username => 'user', :domain => 'example.com')}.to raise_error(WhmArgumentError, /Missing required parameter: password/)
      end

      it "should create the account with proper params" do
        message = @account.create(:username => 'valid', :password => 'hummingbird123', :domain => 'valid-thing.com')
        message[:success].should be_true
        message[:message].should match(/Account Creation Ok/i)
        message[:params].should_not be_empty
        message[:params].should have_key(:options)
        message[:params][:options].should include(:nameserver4, :nameserver, :nameserverentry2, :nameserverentry3, 
                                                  :nameserverentry4, :nameserverentry, :ip, :nameservera2, 
                                                  :nameservera3, :package, :nameservera4, :nameserver2, 
                                                  :nameservera, :nameserver3)
      end

      it "should return an error on duplicate accounts" do
        @account.create(:username => 'invalid', :password => 'hummingbird123', :domain => 'invalid-thing.com')
        message = @account.create(:username => 'invalid', :password => 'hummingbird123', :domain => 'invalid-thing.com')
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
        message = @account.remove(:username => 'removeme')
        message[:success].should be_true
        message[:params][:rawout].should match(/Removing DNS Entries/i)
      end

      it "should remove a user and remove DNS when asked" do
        message = @account.remove(:username => 'removeme', :keepdns => 0)
        message[:success].should be_true
        message[:params][:rawout].should match(/Removing DNS Entries/i)
      end

      it "should remove a user but keep DNS" do
        message = @account.remove(:username => 'removeme', :keepdns => 1)
        message[:success].should be_true
        message[:params][:rawout].should_not match(/Removing DNS Entries/i)
      end

      it "should return an error when the user doesn't exist" do
        message = @account.remove(:username => 'notreal')
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
        expect { @account.change_password(:username => 'changeme') }.to raise_error(WhmArgumentError, /Missing required parameter: pass/)
      end

      it "should change the password" do
        message = @account.change_password(:username => 'changeme', :pass => 'superpass')
        message[:success].should be_true
        message[:message].should match(/Password changed for user changeme/i)
      end

      it "should not be successful when the user doesn't exist" do
        message = @account.change_password(:username => 'dontchangeme', :pass => 'superpass')
        message[:success].should be(false)
        message[:message].should match(/dontchangeme does not exist/i)
      end
    end

    describe "limit bandwidth" do
      use_vcr_cassette "whm/account/limitbw"

      it "should require a user" do
        expect { @account.limit_bandwidth(:bwlimit => 99999) }.to raise_error(WhmArgumentError, /Missing required parameter: username/i)
      end

      it "should require a bandwidth" do
        expect { @account.limit_bandwidth(:username => 'changeme') }.to raise_error(WhmArgumentError, /Missing required parameter: bwlimit/i)
      end

      it "should set the bandwidth limit" do
        result = @account.limit_bandwidth(:username => 'changeme', :bwlimit => 99999)
        result[:success].should be_true
        result[:message].should match(/Bandwidth Limit for changeme set to 99999/i)
      end

      it "should not be successful when the user doesn't exist" do
        expect { @account.limit_bandwidth(:username => 'notexists', :bwlimit => 99999) }.to raise_error(WhmInvalidUser, /User notexists does not exist/i)
      end
    end 

    describe "list", :wip => true do
      use_vcr_cassette "whm/account/listaccts"

      it "should list all accounts" do
        result = @account.list_accounts
        result[:success].should be_true
        result[:params][:acct].should have(10).accounts
      end

      it "should return data for the account" do
        result = @account.list_accounts(:searchtype => 'user', :search => 'changeme')
        result[:success].should be_true
        account = result[:params][:acct].first
        account[:email].should == "*unknown*"
        account[:shell].should == "/usr/local/cpanel/bin/noshell"
        account[:theme].should == "x3"
        account[:plan].should == "default"
      end

      it "should list accounts that match a regex search for the user" do
        result = @account.list_accounts(:searchtype => 'user', :search => 'changeme')
        result[:success].should be_true
        result[:params][:acct].should have(1).account
      end

      it "should list accounts that match a regex search for the ip" do
        result = @account.list_accounts(:searchtype => 'ip', :search => '174\..*?\.166\.173')
        result[:success].should be_true
        result[:params][:acct].should have(6).accounts
      end

      it "should list accounts that match a regex search for the domain" do
        result = @account.list_accounts(:searchtype => 'domain', :search => 'ch.*?e.com')
        result[:success].should be_true
        result[:params][:acct].should have(1).account
      end
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
        result = @account.summary(:username => 'notexists')
        result[:success].should_not be_true
        result[:message].should match(/does not exist/i)
      end

      it "should return a summary" do
        result = @account.summary(:username => 'summary')
        result[:success].should be_true
        result[:message].should match(/ok/i)
      end
    end 

    describe "suspend" do
      use_vcr_cassette "whm/account/suspend"
      it "should require a user" do
        expect { @account.suspend }.to raise_error(WhmArgumentError, /Missing required parameter: username/i)
      end

      it "should return an error for invalid users" do
        result = @account.suspend(:username => 'notexists')
        result[:success].should_not be_true
        result[:message].should match(/does not exist/i)
      end

      it "should suspend" do
        result = @account.suspend(:username => 'suspendme')
        result[:success].should be_true
        result[:message].should match(/has been suspended/i)
      end

      it "should suspend with a reason" do
        @account.server.should_receive(:perform_request).with('suspendacct', hash_including(:user => 'suspendme', :reason => 'abusive user'))

        result = @account.suspend(:username => 'suspendme', :reason => 'abusive user')
      end
    end 

    describe "unsuspend" do
      use_vcr_cassette "whm/account/unsuspend"
      it "should require a user" do
        expect { @account.unsuspend }.to raise_error(WhmArgumentError, /Missing required parameter: username/i)
      end

      it "should return an error for invalid users" do
        result = @account.unsuspend(:username => 'notexists')
        result[:success].should_not be_true
        result[:message].should match(/does not exist/i)
      end

      it "should unsuspend" do
        result = @account.unsuspend(:username => 'asdfasdf')
        result[:success].should be_true
        result[:message].should match(/unsuspending .* account/i)
      end
    end 

    describe "list_suspended" do
      use_vcr_cassette 'whm/account/listsuspended'
      it "should return non-empty result" do
        # empty isn't a real param. VCR Hacks
        result = @account.list_suspended(:empty => true)
        result[:success].should be_true
        result[:params][:accts].should_not be_empty
        result[:params][:accts].first.should include(:user => 'removeme')
      end

      it "should return empty result" do
        result = @account.list_suspended
        result[:success].should be_true
        result[:params][:accts].should be_empty
      end
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

    describe "verify_user" do
      use_vcr_cassette "whm/account/accountsummary"

      it "should not call the block if the user doesn't exist" do
        something = double()
        something.should_not_receive(:gold)
        expect { 
          @account.send(:verify_user, 'notexists') do
            something.gold
          end
        }.to raise_error(WhmInvalidUser)
      end

      it "should call the block if the user does exist" do
        something = double()
        something.should_receive(:gold)
        @account.send(:verify_user, 'summary') do
          something.gold
        end
      end
    end
  end
end
