require "spec_helper"

module Lumberg
  describe Cpanel::BoxTrapper do
    let(:server) { Whm::Server.new(:host => @whm_host, :hash => @whm_hash) }
    let(:api_username) { "lumberg" }
    let(:boxtrapper) do
      described_class.new(
        :server       => server,
        :api_username => api_username
      )
    end

    describe "::api_module" do
      subject { described_class::api_module }

      it { should == "BoxTrapper" }
    end

    describe "#list" do
      use_vcr_cassette("cpanel/box_trapper/list")

      subject { boxtrapper.list[:params][:data] }

      it { should be_an(Array) }
    end
  end
end
