require "spec_helper"

module Lumberg
  describe Cpanel::RandomData do
    let(:server) { Whm::Server.new(:host => @whm_host, :hash => @whm_hash) }
    let(:api_username) { "lumberg" }
    let(:random_data) do
      described_class.new(
        :server       => server,
        :api_username => api_username
      )
    end

    describe "#show" do
      use_vcr_cassette "cpanel/random_data/show"

      it "gets a random string" do
        result = random_data.show({ :length => 10 })[:params][:data]
        result[0][:random].size.should === 10
      end
    end

  end
end
