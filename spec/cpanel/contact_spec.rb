require "spec_helper"

module Lumberg
  describe Cpanel::Contact do
    let(:server) { Whm::Server.new(:host => @whm_host, :hash => @whm_hash) }
    let(:api_username) { "lumberg" }
    let(:contact) do
      described_class.new(
        :server       => server,
        :api_username => api_username
      )
    end

    subject { contact }

    describe "::api_module" do
      subject { described_class::api_module }

      it { should == "Contactus" }
    end

    describe "#contact" do
      use_vcr_cassette("cpanel/contact/contact")

      subject { contact.contact[:params][:data].first[:status] }

      it { should == 1 }
    end

    describe "#status" do
      context "contact option enabled" do
        use_vcr_cassette("cpanel/contact/status")

        subject { contact.status[:params][:data].first[:enabled] }

        it { should == 1 }
      end

      context "contact option disabled" do
        use_vcr_cassette("cpanel/contact/status.disabled")

        subject { contact.status[:params][:data].first[:enabled] }

        it { should == 0 }
      end
    end
  end
end
