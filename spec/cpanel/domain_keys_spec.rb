require "spec_helper"

module Lumberg
  describe Cpanel::DomainKeys do
    let(:server) { Whm::Server.new(:host => @whm_host, :hash => @whm_hash) }
    let(:api_username) { "lumberg" }
    let(:domain_keys) do
      described_class.new(
        :server       => server,
        :api_username => api_username
      )
    end

    describe "#installed" do
      use_vcr_cassette "cpanel/domain_keys/installed"

      it "checks if DomainKeys was installed for domain" do
        domain_keys.installed[:params][:data][0][:installed].should == 1
      end
    end

    describe "#available" do
      use_vcr_cassette "cpanel/domain_keys/available"

      it "checks if DomainKeys is available on local server" do
        domain_keys.available[:params][:data][0][:available].should == 1
      end
    end

    describe "#add" do
      use_vcr_cassette "cpanel/domain_keys/add"

      subject { domain_keys.add[:params][:data][0] }
      it { should be_a(Hash) }
    end

    describe "#remove" do
      use_vcr_cassette "cpanel/domain_keys/remove"

      subject { domain_keys.add[:params][:data][0] }
      it { should be_a(Hash) }
    end

  end
end

