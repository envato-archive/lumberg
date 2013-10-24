require "spec_helper"

module Lumberg
  describe Cpanel::DnsLookup do
    let(:server) { Whm::Server.new(host: @whm_host, hash: @whm_hash) }
    let(:api_username) { "lumberg" }
    let(:dns_lookup) do
      described_class.new(
        server:       server,
        api_username: api_username
      )
    end

    describe "#name_to_ip" do
      use_vcr_cassette "cpanel/dns_lookup/name_to_ip"

      subject { dns_lookup.name_to_ip({ domain: 'google.com' })[:params][:data] }

      it { should be_an(Array) }
    end
  end
end
