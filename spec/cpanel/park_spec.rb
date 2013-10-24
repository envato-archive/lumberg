require "spec_helper"

module Lumberg
  describe Cpanel::Park do
    before(:each) do
      @login    = { host: @whm_host, hash: @whm_hash }
      @server   = Whm::Server.new(@login.dup)

      @api_username = "lumberg"
      @park = Cpanel::Park.new(
        server:       @server.dup,
        api_username: @api_username
      )
    end

    describe "#add" do
      use_vcr_cassette "cpanel/park/add"

      it "creates a new parked domain" do
        # Remove first
        @park.remove(domain: "test-park.com")

        result = @park.add(domain: "test-park.com")
        result[:params][:data].first[:result].should == 1
      end
    end

    describe "#remove" do
      use_vcr_cassette "cpanel/park/remove"

      it "removes a parked domain" do
        # Add first
        @park.add(domain: "test-park.com")

        result = @park.remove(domain: "test-park.com")
        result[:params][:data].first[:result].should == 1
      end
    end

    describe "#list" do
      use_vcr_cassette "cpanel/park/list"

      context "parked domains exist on the account" do
        let(:result) { @park.list }
        subject { result[:params][:data] }

        it "returns an array with info for each parked domain" do
          subject.should be_an(Array)
          subject.each {|info|
            info.keys.should include(
              :status, :reldir, :dir, :basedir, :domain
            )
          }
        end
      end

      context "no parked domains exist on the account" do
        before { @park.api_username = "minimal" }
        after { @park.api_username = "lumberg" }

        it "returns an empty array" do
          @park.list[:params][:data].should be_empty
        end
      end
    end

    describe "#list_addon_domains" do
      use_vcr_cassette "cpanel/park/list_addon_domains"

      context "addon domains exist on the account" do
        let(:result) { @park.list_addon_domains }
        subject { result[:params][:data] }

        it "returns an array with info for each addon domain" do
          subject.should be_an(Array)
          subject.each {|info|
            info.keys.should include(
              :status, :reldir, :dir, :basedir, :domain
            )
          }
        end
      end

      context "no addon domains exist on the account" do
        before { @park.api_username = "minimal" }
        after { @park.api_username = "lumberg" }

        it "returns an empty array" do
          @park.list_addon_domains[:params][:data].should be_empty
        end
      end
    end
  end
end
