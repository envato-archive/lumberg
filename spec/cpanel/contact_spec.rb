require "spec_helper"

module Lumberg
  describe Cpanel::Contact do
    let(:server) { Whm::Server.new(host: @whm_host, hash: @whm_hash) }
    let(:api_username) { "lumberg" }
    let(:contact) do
      described_class.new(
        server:       server,
        api_username: api_username
      )
    end

    subject { contact }

    describe "::api_module" do
      subject { described_class::api_module }

      it { should == "CustInfo" }
    end

    describe "#show" do
      use_vcr_cassette("cpanel/contact/show", record: :new_episodes)
      subject { contact.show[:params][:data].first[:enabled] }
      it { should == 1 }
    end

    describe "#update" do
      let(:email_address) { "testing@lumberg-test.com" }
      let(:result) { Hash.new }

      use_vcr_cassette("cpanel/contact/update", record: :new_episodes)

      context "configure contact email address and enables notifications" do
        it "should setup email address and bandwidth limit notification" do
          res = contact.update({ email: email_address, bandwidth: 1 })

          res[:params][:data].collect do |r|
            if ((r[:name] == 'email') or (r[:name] == 'notify_bandwidth_limit'))
              result[:"#{r[:name]}"] = r[:value]
            end
          end

          result[:email].should === email_address
          result[:notify_bandwidth_limit].should === 1
        end
      end
    end
  end
end
