require "spec_helper"

module Lumberg
  describe Cpanel::Net do
    let(:server) { Whm::Server.new(host: @whm_host, hash: @whm_hash) }
    let(:api_username) { "lumberg" }
    let(:net) do
      described_class.new(
        server:       server,
        api_username: api_username
      )
    end

    describe "#traceroute" do
      use_vcr_cassette "cpanel/net/traceroute"

      subject { net.traceroute[:params][:data] }

      it { should be_an(Array) }
    end

    describe "#query_hostname" do
      use_vcr_cassette "cpanel/net/query_hostname"

      subject { net.query_hostname({ host: 'google.com' })[:params][:data] }

      it { should be_an(Array) }
    end
  end
end
