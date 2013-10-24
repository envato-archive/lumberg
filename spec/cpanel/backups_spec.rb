require "spec_helper"

module Lumberg
  describe Cpanel::Backups do
    let(:server) { Whm::Server.new(host: @whm_host, hash: @whm_hash) }
    let(:api_username) { "lumberg" }
    let(:backups) do
      described_class.new(
        server: server,
        api_username: api_username
      )
    end

    describe "#list" do
      use_vcr_cassette("cpanel/backups/list")

      subject { backups.list[:params][:data] }

      it { should be_an(Array) }
    end
  end
end
