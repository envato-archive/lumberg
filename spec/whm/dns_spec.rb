require 'spec_helper'
require 'lumberg/whm'

module Lumberg
  describe Whm::Dns do
    before(:each) do
      @login    = { host: @whm_host, hash: @whm_hash }
      @server   = Whm::Server.new(@login.dup)
      @dns      = Whm::Dns.new(server: @server.dup)
    end

    describe "#addzone" do
      use_vcr_cassette "whm/dns/adddns"

      it "creates a zone" do
        result = @dns.add_zone(domain: 'example.com', ip: '192.1.2.3')
        result[:success].should be_true
        result[:message].should match(/added example\.com .*user root.*/i)
      end

      it "creates a zone under a user" do
        result = @dns.add_zone(domain: 'example.com', ip: '192.1.2.3', trueowner: 'something')
        result[:success].should be_true
        result[:message].should match(/added example\.com .*user something.*/i)
      end
    end

    describe "#addzonerecord" do
      use_vcr_cassette "whm/dns/addzonerecord"

      it "adds a zone record" do
        result = @dns.add_zone_record(zone:    'example.com',
                                      name:    'example.com.',
                                      address: '192.1.2.3',
                                      type:    'A')
        result[:success].should be_true
        result[:message].should match(/Bind reloading on .*example.com/i)
      end

      it "adds a zone record reverse" do
        result = @dns.add_zone_record(zone:     'example.com',
                                      name:     '1',
                                      ptdrname: 'example.com',
                                      type:     'PTR')
        result[:success].should be_true
        result[:message].should match(/Bind reloading on .*example.com/i)
      end
    end

    describe "#listzones" do
      use_vcr_cassette "whm/dns/listzones"

      it "lists all the zones" do
        result = @dns.list_zones
        params = result[:params]
        params.size.should == 2
        params[0][:zonefile].should == "thisisathrowawayagain22.com.db"
        params[0][:domain].should == "thisisathrowawayagain22.com"
      end
    end

    describe "#getzonerecord" do
      use_vcr_cassette "whm/dns/getzonerecord"

      it "returns the zone" do
        result = @dns.get_zone_record(domain: "example.com", Line: 1)
        result[:success].should be_true
        result[:message].should match(/Record obtained/i)
        result[:params][:record][:Line].should == 1
        result[:params][:record][:raw].should == "; cPanel 11.25.0-STABLE_44718"
      end

      it "returns an error when the domain was not found" do
        result = @dns.get_zone_record(domain: "notexists.com", Line: 1)
        result[:success].should_not be_true
        result[:message].should match(/Zone does not exist/i)
      end

      it "returns an error for a line with no data" do
        result = @dns.get_zone_record(domain: "example.com", Line: 20)
        result[:success].should be_false
        result[:message].should match(/No record available on selected line/i)
      end
    end


    describe "#get_nameserver_config" do
      use_vcr_cassette "whm/dns/get_nameserver_config"

      it "returns the nameservers" do
        result = @dns.get_nameserver_config("api.version".to_sym => 1)
        nameservers = result[:params][:nameservers]
        nameservers.size.should == 2
        nameservers.should be_include('ns1.example.com')
        nameservers.should be_include('ns2.example.com')
      end
    end

    describe "#dumpzone" do
      use_vcr_cassette "whm/dns/dumpzone"

      it "dumps the zone" do
        result = @dns.dump_zone(domain: "example.com")
        result[:success].should be_true
        result[:message].should match(/Zone Serialized/i)
        result[:params][:record][0][:raw].should match(/; cPanel first:11\.25\.0-STABLE_44718 latest:11\.28\.64-STABLE_51024 Cpanel::ZoneFile::VERSION:1\.3 mtime:1299509628/i)
        result[:params][:record][20][:ttl].should == "14400"
      end

      it "returns an error when the domain is not found" do
        result = @dns.dump_zone(domain: "notexists.com")
        result[:success].should be_false
        result[:message].should match(/Zone does not exist/i)
      end
    end

    describe "#resolvedomainname" do
      use_vcr_cassette "whm/dns/resolvedomainname"

      it "returns the ip address of the domain" do
        result = @dns.resolve_domain(domain: "example.com", "api.version".to_sym => 1)
        result[:params][:ip].should == "192.1.2.3"
      end

      it "returns an error when the ip address cannot be determined" do
        result = @dns.resolve_domain(domain: "notexists.com", "api.version".to_sym => 1)
        result[:params][:ip].should be_nil
        result[:message].should match(/Unable to resolve domain name/i)
      end
    end

    describe "#editzonerecord" do
      use_vcr_cassette "whm/dns/editzonerecord"

      it "updates the zone record" do
        result = @dns.edit_zone_record(domain: "example.com", Line: 1, ttl: "86400")
        result[:success].should be_true
        result[:message].should match(/Bind reloading on .* using rndc zone.*example.com/i)
      end

      it "returns an error for an unknown domain or invalid Line" do
        result = @dns.edit_zone_record(domain: "notexists.com", Line: 1, ttl: "86400")
        result[:success].should be_false
        result[:message].should match(/Failed to serialize record/i)
      end

      it "returns an error for an invalid Line" do
        result = @dns.edit_zone_record(domain: "example.com", Line: 200, ttl: "86400")
        result[:success].should be_false
        result[:message].should match(/Failed to serialize record/i)
      end
    end

    describe "#killdns" do
      use_vcr_cassette "whm/dns/killdns"

      it "kills the dns" do
        result = @dns.kill_dns(domain: "example.com")
        result[:success].should be_true
        result[:message].should match(/Zones Removed/i)
      end

      it "returns an error when the domain does not exist" do
        result = @dns.kill_dns(domain: "notexists.com")
        result[:success].should be_false
        result[:message].should match(/Unable to remove zone that does not exist/i)
      end
    end

    describe "#lookupnsip" do
      use_vcr_cassette "whm/dns/lookupnsip"

      it "returns the nameserver's ip" do
        result = @dns.lookup_nameserver_ip(nameserver: "example.com")
        result[:params][:ip].should == "192.1.2.3"
      end

      it "returns null if the ip cannot be determined" do
        result = @dns.lookup_nameserver_ip(nameserver: "notexists.com")
        result[:params][:ip].should be_nil
      end
    end

    describe "#removezonerecord" do
      use_vcr_cassette "whm/dns/removezonerecord"

      it "removes the zone record" do
        result = @dns.remove_zone_record(zone: "example.com", Line: 1)
        result[:success].should be_true
        result[:message].should match(/Bind reloading on .*example.com/i)
      end

      it "returns an error for an unknown zone " do
        result = @dns.remove_zone_record(zone: "notexists.com", Line: 1)
        result[:success].should be_false
        result[:message].should match(/Unable to find a record on specified line/i)
      end

      it "returns an error for an invalid line" do
        result = @dns.remove_zone_record(zone: "example.com", Line: 200)
        result[:success].should be_false
        result[:message].should match(/Unable to find a record on specified line/i)
      end
    end

    describe "#resetzone" do
      use_vcr_cassette "whm/dns/resetzone"

      it "resets the zone" do
        result = @dns.reset_zone(domain: "example.com", zone: "example.com")
        result[:success].should be_true
        result[:message].should match(/Bind reloading on .*example.com/i)
      end

      it "returns an error for an unknown domain" do
        result = @dns.reset_zone(domain: "notexists.com", zone: "notexists.com")
        result[:success].should be_false
        result[:message].should match(/Unable to determine the IP address for notexists.com/i)
      end
    end

    describe "#listmxs" do
      use_vcr_cassette "whm/dns/listmxs"

      it "returns a list of mxs" do
        result = @dns.list_mxs(domain: "example.com", "api.version".to_sym => 1)
        result[:params][:record].should be_a_kind_of Array
        result[:params][:record].size.should == 1
        result[:params][:record].first[:exchange].should == "example.com"
        result[:params][:record].first[:name].should == "example.com."
      end
    end

    describe "#savemxs" do
      use_vcr_cassette "whm/dns/savemxs"

      it "saves the mx record" do
        result = @dns.save_mx("api.version".to_sym => 1,
                              domain:     "example.com",
                              name:       "mail.example.com",
                              exchange:   "example.com",
                              preference: 10)
        result[:message].should match(/Bind reloading on .*example.com/i)
      end
    end
  end
end
