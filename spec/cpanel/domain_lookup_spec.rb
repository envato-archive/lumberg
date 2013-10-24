require "spec_helper"

module Lumberg
  describe Cpanel::DomainLookup do
    let(:server) { Whm::Server.new(host: @whm_host, hash: @whm_hash) }
    let(:api_username) { "lumberg" }
    let(:domain_lookup) do
      described_class.new(
        server:       server,
        api_username: api_username
      )
    end

    let(:domain) { "lumberg-test.com" }
    let(:document_root) { "/home/lumberg/public_html" }

    describe "#list" do
      use_vcr_cassette "cpanel/domain_lookup/list"

      it "shows parked domains, addon domains and main domain" do
        domain_lookup.list[:params][:data][0][:domain].should === domain
      end
    end

    describe "#document_root" do
      use_vcr_cassette "cpanel/domain_lookup/document_root"

      it "gets DocumentRoot for domain" do
        result = domain_lookup.document_root({ domain: domain })

        result[:params][:data][0][:docroot].should == document_root
      end
    end

    describe "#docroot" do
      use_vcr_cassette "cpanel/domain_lookup/docroot"

      it "gets DocumentRoot for domain, as an alias for #document_root" do
        result = domain_lookup.document_root({ domain: domain })

        result[:params][:data][0][:docroot].should == document_root
      end
    end


    describe "#document_roots" do
      use_vcr_cassette "cpanel/domain_lookup/document_roots"

      subject { domain_lookup.document_roots[:params][:data] }

      it "gets DocumentRoot for all domains" do
        should be_an(Array)
      end
    end

    describe "#docroots" do
      use_vcr_cassette "cpanel/domain_lookup/docroots"

      subject { domain_lookup.document_roots[:params][:data] }

      it "gets DocumentRoot for all domains, as an alias for #document_roots" do
        should be_an(Array)
      end
    end

    describe "#count" do
      use_vcr_cassette "cpanel/domain_lookup/count"

      it "gets the total number of domains associated within a Cpanel account" do
        result = domain_lookup.count

        result[:params][:data][0][:count].should > 0
      end
    end

  end
end
