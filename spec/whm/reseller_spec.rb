require 'spec_helper'

module Lumberg
  describe Whm::Reseller do
    before(:each) do
      @login    = { :host => @whm_host, :hash => @whm_hash }
      @whm      = Whm::Server.new(@login.dup)
      @reseller = Whm::Reseller.new(:server => @whm)
    end

    describe "#setup_reseller" do
      use_vcr_cassette "whm/reseller/setupreseller"

      it "requires username" do
        requires_attr('username') { @reseller.create }
      end

      it "creates a reseller" do
        result = @reseller.create(:username => 'bob')
        result[:success].should be_true
      end

      it "accepts makeowner option" do
        @reseller.server.should_receive(:perform_request).with('setupreseller', hash_including(:makeowner => true))
        @reseller.create(:username => 'bob', :makeowner => true)
      end
    end
  end
end
