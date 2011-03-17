require 'spec_helper'

module Lumberg
  describe Whm::Reseller do
    before(:each) do
      @login    = { :host => @whm_host, :hash => @whm_hash }
      @whm      = Whm::Server.new(@login.dup)
      @reseller = Whm::Reseller.new(:server => @whm)
    end

    describe "#setup_reseller" do
      use_vcr_cassette "whm/reseller/setupreseller"

      it "requires username" do
        requires_attr('username') { @reseller.create }
      end

      it "fails when the user doesn't exist" do
        result = @reseller.create(:username => 'invalid')
        result[:success].should be_false
        result[:message].should match(/does not exist/i)
      end

      it "creates a reseller" do
        result = @reseller.create(:username => 'bob')
        result[:success].should be_true
      end

      it "accepts makeowner option" do
        @reseller.server.should_receive(:perform_request).with('setupreseller', hash_including(:makeowner => true))
        @reseller.create(:username => 'bob', :makeowner => true)
      end
    end

    describe "#list" do
      use_vcr_cassette "whm/reseller/listresellers"

      it "lists all resellers" do
        result = @reseller.list
        result[:success].should be_true
        result[:params][:resellers].should have(2).resellers
        result[:params][:resellers].should include('bob', 'ted')
      end
    end 

    describe "#setresellerips" do
      use_vcr_cassette "whm/reseller/setresellerips"

      it "requires a username" do
        requires_attr('username') { @reseller.add_ips }
      end

      it "adds the ip address to the reseller account" do
        result = @reseller.add_ips(:username => 'bob', :ips =>'192.1.2.3')
        result[:message].should match(/Successfully configured IP addresses delegation to reseller/i)
      end

      it "returns an error for invalid ip addresses" do
        result = @reseller.add_ips(:username => 'bob', :ips =>'1.2.3.4')
        result[:message].should match(/The list of supplied IP addresses contains inappropriate values/i)
      end
    end

    describe "#setresellerlimits" do
      use_vcr_cassette "whm/reseller/setresellerlimits"

      it "requires a username" do
        requires_attr('username') { @reseller.set_limits }
      end

      it "sets the limits" do
        result = @reseller.set_limits(:username => 'bob', :diskspace_limit => 1024, :enable_overselling => true, 
                                      :enable_overselling_diskspace => true)
        result[:success].should be_true
        result[:message].should match(/Successfully set reseller account .*limits/i)
      end
    end

    describe "#terminate" do
      use_vcr_cassette "whm/reseller/terminatereseller"

      it "requires a reseller" do
        requires_attr('reseller') { @reseller.terminate }
      end

      it "terminates the reseller" do
        result = @reseller.terminate(:reseller => 'terminat')
        result[:success].should be_true
        result[:message].should match(/account terminations complete/i)
        result[:params][:accts].should be_empty
      end

      it "terminates the main account" do
        result = @reseller.terminate(:reseller => 'terminat', :terminatereseller => true)
        result[:success].should be_true
        result[:message].should match(/account terminations complete/i)
        result[:params][:accts][:terminat][:rawout].should match(/Account Removal Complete/i)
      end

      it "errors on non-existaet user" do
        result = @reseller.terminate(:reseller => 'what')
        result[:success].should be_false
        result[:message].should match(/does not exist/i)
      end

    end

    describe "#setresellermainip" do
      use_vcr_cassette "whm/reseller/setresellermainip"

      it "requires a username" do
        requires_attr('username') { @reseller.set_main_ip(:ip => '192.1.2.3') }
      end

      it "requires an ip" do
        requires_attr('ip') { @reseller.set_main_ip(:username => 'bob') }
      end

      it "sets the main ip" do
        result = @reseller.set_main_ip(:username => 'bob', :ip => '192.1.2.3')
        result[:success].should be_true
        result[:message].should match(/Successfully set main IP address of the reseller/i)
      end

      it "returns an error when the IP is invalid" do
        result = @reseller.set_main_ip(:username => 'bob', :ip => '10')
        result[:success].should be_false
        result[:message].should match(/Supplied IP address is invalid/)
      end

      it "returns an error when the user is invalid" do
        result = @reseller.set_main_ip(:username => 'notexists', :ip => '192.1.2.3')
        result[:success].should be_false
        result[:message].should match(/Specified user is not a reseller/i)
      end
    end

    describe "#setresellerpackagelimit" do
      use_vcr_cassette "whm/reseller/setresellerpackagelimit"

      it "requires a username" do
        requires_attr('username') { @reseller.set_package_limit(:no_limit => true, :package => 'gold') }
      end

      it "requires no_limit" do
        requires_attr('no_limit') { @reseller.set_package_limit(:username => 'bob', :package => 'gold') }
      end

      it "requires package" do
        requires_attr('package') { @reseller.set_package_limit(:username => 'bob', :no_limit => true) }
      end

      it "sets the package limit" do
        result = @reseller.set_package_limit(:username => 'bob', :no_limit => false, :package => 'gold', :allowed => true)
        result[:success].should be_true
        result[:message].should match(/Successfully set reseller package limit/i)
      end

      it "sets no limit" do
        result = @reseller.set_package_limit(:username => 'bob', :no_limit => true, :package => 'gold')
        result[:success].should be_true
        result[:message].should match(/Successfully set reseller package limit/i)
      end
    end                                                                                                   

    describe "#suspendreseller" do
      use_vcr_cassette "whm/reseller/suspendreseller"

      it "requires a username" do
        requires_attr('username') { @reseller.suspend }
      end

      it "suspends the reseller" do
        result = @reseller.suspend(:username => 'bob')
        result[:success].should be_true
        result[:message].should match(/Finished suspending reseller/i)
      end

      it "can take a reason" do
        result = @reseller.suspend(:username => 'bob', :reason => 'some reason')
        result[:success].should be_true
        result[:message].should match(/Finished suspending reseller/i)
      end

      it "returns an error when the user is invalid" do
        result = @reseller.suspend(:username => 'notexists')
        result[:success].should be_false
        result[:message].should match(/Specified user is not a reseller/i)
      end
    end

    describe "#unsuspendreseller" do
      use_vcr_cassette "whm/reseller/unsuspendreseller"

      it "requires a username" do
        requires_attr('username') { @reseller.unsuspend }
      end

      it "should unsuspend the user" do
        result = @reseller.unsuspend(:username => 'bob')
        result[:success].should be_true
        result[:message].should match(/Finished unsuspending reseller/i)
      end

      it "return an error when the user is invalid" do
        result = @reseller.unsuspend(:username => 'notexists')
        result[:success].should be_false
        result[:message].should match(/Specified user is not a reseller/i)
      end
    end

    describe "#acctcounts" do
      use_vcr_cassette "whm/reseller/acctcounts"

      it "requires a username" do
        requires_attr('username') { @reseller.account_counts }
      end

      it "returns the account counts" do
        result = @reseller.account_counts(:username => 'bob')
        result[:success].should be_true
        result[:message].should match(/Obtained reseller account counts/i)
        result[:params][:account].should == "bob" 
        result[:params][:suspended].to_i.should == 0
        result[:params][:active].to_i.should == 0
        result[:params][:limit].should == "" 
      end

      it "returns an error when the user is invalid" do
        result = @reseller.account_counts(:username => 'notexists')
        result[:success].should be_false
        result[:message].should match(/Specified user is not a reseller/i)
      end
    end

    describe "#setresellernameservers" do
      use_vcr_cassette "whm/reseller/setresellernameservers"

      it "requires a username" do
        requires_attr('username') { @reseller.set_nameservers }
      end

      it "sets the default nameservers" do
        result = @reseller.set_nameservers(:username => 'bob')
        result[:success].should be_true
        result[:message].should match(/Set resellers nameservers/i)
      end
      
      it "sets the specified nameservers" do
        result = @reseller.set_nameservers(:username => 'bob', :nameservers => 'ns1.example.com')
        result[:success].should be_true
        result[:message].should match(/Set resellers nameservers/i)
      end
      
      it "returns an error for an invalid username" do
        result = @reseller.account_counts(:username => 'notexists')
        result[:success].should be_false
        result[:message].should match(/Specified user is not a reseller/i)
      end
    end

    describe "#resellerstats" do
      use_vcr_cassette "whm/reseller/resellerstats"

      it "requires a reseller" do
        requires_attr('reseller') { @reseller.stats }
      end

      it "returns the stats of the reseller" do
        result = @reseller.stats(:reseller => 'bob')
        result[:success].should be_true
        result[:message].should match(/Fetched Reseller Data OK/i)
        result[:params][:diskquota].to_i.should == 0
        result[:params][:diskoverselling].to_i.should == 1 
        result[:params][:bandwidthlimit].to_i.should == 0
      end

      it "returns an error for an invalid reseller" do
        result = @reseller.stats(:reseller => 'notexists')
        result[:success].should be_false
        result[:message].should match(/Reseller Does Not Exist/i)
      end
    end

    describe "#listacls" do
      use_vcr_cassette "whm/reseller/listacls"

      it "lists the saved reseller ACL lists" do
        result = @reseller.list_acls
        result[:params].size.should == 1
        result[:params][:testacllist][:add_pkg].to_i.should == 1
        result[:params][:testacllist][:add_pkg_ip].to_i.should == 1
        result[:params][:testacllist][:edit_mx].to_i.should == 0
      end
    end

    describe "#saveacllist" do
      use_vcr_cassette "whm/reseller/saveacllist"

      it "requires an acllist name" do
        requires_attr('acllist') { @reseller.save_acl_list }
      end

      it "creates a new reseller ACL list" do
        result = @reseller.save_acl_list(:acllist => 'testacllist')
        result[:success].should be_true
        result[:message].should match(/ACL List testacllist saved/i)
      end

      it "creates a new reseller ACL list with optional settings" do
        result = @reseller.save_acl_list(:acllist => 'testacllist', 
                                         "acl-ssl".to_sym => true,
                                         "acl-add-pkg".to_sym => true, 
                                         "acl-stats".to_sym => true)
        result[:success].should be_true
        result[:message].should match(/ACL List testacllist saved/i)
      end
    end

    describe "#setacls" do
      use_vcr_cassette "whm/reseller/setacls"

      it "requires a reseller" do
        requires_attr('reseller') { @reseller.set_acls }
      end

      it "sets the ACL for the reseller" do
        result = @reseller.set_acls(:reseller => 'bob', :acllist => 'testacllist')
        result[:success].should be_true
        result[:message].should match(/Reseller Acls Saved/i)
      end
      
      it "returns an error for an invalid reseller" do
        result = @reseller.set_acls(:reseller => 'notexists')
        result[:success].should be_false
        result[:message].should match(/Not a reseller/i)
      end
    end

    describe "#unsetupreseller" do
      use_vcr_cassette "whm/reseller/unsetupreseller"

      it "requires a username" do
        requires_attr('username') { @reseller.unsetup }
      end

      it "removes the reseller status from the user" do
        result = @reseller.unsetup(:username => 'bob')
        result[:success].should be_true
      end

      it "returns an error if the user does not exist" do
        result = @reseller.unsetup(:username => 'notexists')
        result[:success].should be_false
        result[:message].should match(/called for a user that does not exist/i)
      end
    end
  end
end
