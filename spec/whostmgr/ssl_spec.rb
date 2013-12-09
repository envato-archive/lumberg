require "spec_helper"

module Lumberg
  module Whostmgr
    describe Ssl do
      let(:ssl)    {  described_class.new(server: server) }
      let(:domain) { "lumberg-test.com" }

      let(:server) do
        Whm::Server.new(host: @whm_host, hash: @whm_hash, whostmgr: true)
      end

      describe "#remove" do
        use_vcr_cassette "whostmgr/ssl/remove"

        it "removes the cert" do
          ssl.remove(
            domain: domain
          )[:message].should eq "successfully deleted"
        end
      end

      describe "#remove_data" do
        use_vcr_cassette "whostmgr/ssl/remove_data"

        it "removes the cert data" do
          ssl.remove_data(
            id: 'c2600_26b3b_0e30b9d45805332236d6e4adf003f1b3', type: 'key'
          )[:message].should eq "deleted successfully"
        end
      end
    end
  end
end
