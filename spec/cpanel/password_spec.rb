require "spec_helper"

module Lumberg
  describe Cpanel::Password do
    let(:server) { Whm::Server.new(host: @whm_host, hash: @whm_hash) }
    let(:api_username) { "lumberg" }
    let(:password) do
      described_class.new(
        server:       server,
        api_username: api_username
      )
    end

    let(:random_password) { "realtopsecretpassword" }

    describe "#modify" do
      use_vcr_cassette "cpanel/password/modify"

      it "sets a new password for account" do
        result = password.modify({ old: '12345', new: random_password })
        result[:params][:data][0].should be_a(Hash)
      end
    end

    describe "#digest_authentication" do
      use_vcr_cassette "cpanel/password/digest_authentication"

      it "enables digest authentication for account" do
        result = password.digest_authentication({ password: random_password, enable: true })
        result[:params][:data][0].should be_a(Hash)
      end
    end
  end
end

