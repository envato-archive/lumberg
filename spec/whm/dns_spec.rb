require 'spec_helper'
require 'lumberg/whm'

module Lumberg
  describe Whm::Dns do
    before(:each) do
      @login    = { :host => @whm_host, :hash => @whm_hash }
      @server   = Whm::Server.new(@login.dup)
      @dns      = Whm::Dns.new(:server => @server.dup)
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

    context "add zone record" do
      it "requires a zone" do
        expect { @dns.add_zone_record() }.to raise_error(WhmArgumentError, /Missing.*: zone/)
      end

      use_vcr_cassette "whm/account/addzonerecord"

      it "adds a zone record" do
        result = @dns.add_zone_record(:zone => 'example.com', 
                                      :name => 'example.com.',
                                      :address => '127.0.0.1',
                                      :type => 'A')
        result[:success].should be_true
        result[:message].should match(/Bind reloading on .*example.com/i)
      end
    end

    context "list zones" do
      use_vcr_cassette "whm/account/listzones"

      it "lists all the zones" do
        result = @dns.list_zones
        params = result[:params]
        params.size.should == 2
        params[0][:zonefile].should == "thisisathrowawayagain22.com.db"
        params[0][:domain].should == "thisisathrowawayagain22.com"
      end
    end

    context "get zone record" do
      use_vcr_cassette "whm/account/getzonerecord"

      it "requires a domain" do
        expect { @dns.get_zone_record(:Line => 1) }.to raise_error(WhmArgumentError, /Missing.*: domain/i)
      end

      it "requires a Line" do
        expect { @dns.get_zone_record(:domain => "example.com") }.to raise_error(WhmArgumentError, /Missing.*: Line/i)
      end

      it "returns the zone" do
        result = @dns.get_zone_record(:domain => "example.com", :Line => 1)
        result[:success].should be_true
        result[:message].should match(/Record obtained/i)
        result[:params][:record][:Line].should == 1
        result[:params][:record][:raw].should == "; cPanel 11.25.0-STABLE_44718"
      end

      it "returns an error when the domain was not found" do
        result = @dns.get_zone_record(:domain => "notexists.com", :Line => 1)
        result[:success].should_not be_true
        result[:message].should match(/Zone does not exist/i)
      end

      it "returns an error for a line with no data" do
        result = @dns.get_zone_record(:domain => "example.com", :Line => 20)
        result[:success].should be_false
        result[:message].should match(/No record available on selected line/i)
      end
    end

    context "dumpzone" do
      use_vcr_cassette "whm/account/dumpzone"

      it "requires a domain" do
        expect { @dns.dump_zone }.to raise_error(WhmArgumentError, /Missing.*: domain/i)
      end

      it "dumps the zone" do
        result = @dns.dump_zone(:domain => "example.com")
        result[:success].should be_true
        result[:message].should match(/Zone Serialized/i)
        result[:params][:record][0][:raw].should match(/; cPanel first:11\.25\.0-STABLE_44718 latest:11\.28\.64-STABLE_51024 Cpanel::ZoneFile::VERSION:1\.3 mtime:1299509628/i)
        result[:params][:record][20][:ttl].should == "14400"
      end

      it "returns an error when the domain is not found" do
        result = @dns.dump_zone(:domain => "notexists.com")
        result[:success].should be_false
        result[:message].should match(/Zone does not exist/i)
      end
    end

    context "resolve domain name" do
      use_vcr_cassette "whm/account/resolvedomainname"

      it "requires a domain" do
        expect { @dns.resolve_domain("api.version".to_sym => 1) }.to raise_error(WhmArgumentError, /Missing.*: domain/i)
      end

      it "requires the api version" do
        expect { @dns.resolve_domain(:domain => "example.com") }.to raise_error(WhmArgumentError, /Missing.*: api.version/i)
      end

      it "returns the ip address of the domain" do
        result = @dns.resolve_domain(:domain => "example.com", "api.version".to_sym => 1)
        result[:params][:ip].should == "127.0.0.1"
      end

      it "returns an error when the ip address cannot be determined" do
        result = @dns.resolve_domain(:domain => "notexists.com", "api.version".to_sym => 1)
        result[:params][:ip].should be_nil
        result[:message].should match(/Unable to resolve domain name/i)
      end
    end

    context "edit zone record" do
      use_vcr_cassette "whm/account/editzonerecord"

      it "requires a domain" do
        expect { @dns.edit_zone_record(:Line => 1) }.to raise_error(WhmArgumentError, /Missing.*: domain/i)
      end

      it "requires a Line" do
        expect { @dns.edit_zone_record(:domain => "example.com") }.to raise_error(WhmArgumentError, /Missing.*: Line/i)
      end

      it "updates the zone record" do
        result = @dns.edit_zone_record(:domain => "example.com", :Line => 1, :ttl => "86400")
        result[:success].should be_true
        result[:message].should match(/Bind reloading on .* using rndc zone.*example.com/i)
      end

      it "returns an error for an unknown domain or invalid Line" do
        result = @dns.edit_zone_record(:domain => "notexists.com", :Line => 1, :ttl => "86400")
        result[:success].should be_false
        result[:message].should match(/Failed to serialize record/i)
      end

      it "returns an error for an invalid Line" do
        result = @dns.edit_zone_record(:domain => "example.com", :Line => 200, :ttl => "86400")
        result[:success].should be_false
        result[:message].should match(/Failed to serialize record/i)
      end
    end

    context "kill dns" do
      use_vcr_cassette "whm/account/killdns"

      it "requires a domain" do
        expect { @dns.kill_dns() }.to raise_error(WhmArgumentError, /Missing.*: domain/i)
      end

      it "kills the dns" do
        result = @dns.kill_dns(:domain => "example.com")
        result[:success].should be_true
        result[:message].should match(/Zones Removed/i)
      end

      it "returns an error when the domain does not exist" do
        result = @dns.kill_dns(:domain => "notexists.com")
        result[:success].should be_false
        result[:message].should match(/Unable to remove zone that does not exist/i)
      end
    end

    context "remove zone record" do
      use_vcr_cassette "whm/account/removezonerecord"

      it "requires a zone" do
        expect { @dns.remove_zone_record(:Line => 1) }.to raise_error(WhmArgumentError, /Missing.*: zone/i)
      end

      it "requires a Line" do
        expect { @dns.remove_zone_record(:zone => "example.com") }.to raise_error(WhmArgumentError, /Missing.*: Line/i)
      end

      it "removes the zone record" do
        result = @dns.remove_zone_record(:zone => "example.com", :Line => 1)
        result[:success].should be_true
        result[:message].should match(/Bind reloading on .*example.com/i)
      end

      it "returns an error for an unknown zone " do
        result = @dns.remove_zone_record(:zone => "notexists.com", :Line => 1)
        result[:success].should be_false
        result[:message].should match(/Unable to find a record on specified line/i)
      end

      it "returns an error for an invalid line" do
        result = @dns.remove_zone_record(:zone => "example.com", :Line => 200)
        result[:success].should be_false
        result[:message].should match(/Unable to find a record on specified line/i)
      end
    end

  end
end
