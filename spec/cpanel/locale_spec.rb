require "spec_helper"

module Lumberg
  describe Cpanel::Locale do
    let(:server) { Whm::Server.new(:host => @whm_host, :hash => @whm_hash) }
    let(:api_username) { "lumberg" }
    let(:locale) do
      described_class.new(
        :server       => server,
        :api_username => api_username
      )
    end

    describe "#show" do
      use_vcr_cassette "cpanel/locale/show"

      subject { locale.show[:params][:data][0][:encoding] }

      it { should be_a(String) }
    end
  end
end

