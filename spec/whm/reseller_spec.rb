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

      it "fails when the user doesn't exist" do
        result = @reseller.create(:username => 'invalid')
        result[:success].should be_false
        result[:message].should match(/does not exist/i)
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

    describe "#list" do
      use_vcr_cassette "whm/account/listresellers"

      it "lists all resellers" do
        result = @reseller.list
        result[:success].should be_true
        result[:params][:resellers].should have(2).resellers
        result[:params][:resellers].should include('bob', 'ted')
      end
    end 
  end
end
