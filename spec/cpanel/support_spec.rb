require "spec_helper"

module Lumberg
  describe Cpanel::Support do
    let(:server) { Whm::Server.new(:host => @whm_host, :hash => @whm_hash) }
    let(:api_username) { "lumberg" }
    let(:support) do
      described_class.new(
        :server       => server,
        :api_username => api_username
      )
    end

    subject { support }

    describe "::api_module" do
      subject { described_class::api_module }

      it { should == "Contactus" }
    end

    describe "#open_ticket" do
      context "should open a new support request" do
        pending
      end
    end

    describe "#contactable" do
      context "support option enabled" do
        use_vcr_cassette("cpanel/support/contactable", :record => :new_episodes)

        subject { support.contactable[:params][:data][0][:enabled] }

        it { should == 1 }
      end
    end
  end
end
