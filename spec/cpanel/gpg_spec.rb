require "spec_helper"

module Lumberg
  describe Cpanel::Gpg do
    let(:server) { Whm::Server.new(host: @whm_host, hash: @whm_hash) }
    let(:api_username) { "lumberg" }
    let(:gpg) do
      described_class.new(
        server:       server,
        api_username: api_username
      )
    end

    describe "#list" do
      use_vcr_cassette "cpanel/gpg/list"

      subject { gpg.list[:params][:data] }

      it { should be_an(Array) }
    end

    describe "#count" do
      use_vcr_cassette "cpanel/gpg/count"

      subject { gpg.count[:params][:data][0][:count] }

      it { should be_a(Integer) }
    end

    describe "#list_private" do
      use_vcr_cassette "cpanel/gpg/list_private"

      subject { gpg.list_private[:params][:data] }

      it { should be_an(Array) }
    end

    describe "#count_private" do
      use_vcr_cassette "cpanel/gpg/count_private"

      subject { gpg.count_private[:params][:data][0][:count] }

      it { should be_a(Integer) }
    end

  end
end

