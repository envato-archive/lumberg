require 'spec_helper'
require 'lumberg/whm'
require 'lumberg/cpanel'

module Lumberg
  describe Cpanel::Park do
    before(:each) do
      @login    = { :host => @whm_host, :hash => @whm_hash }
      @server   = Whm::Server.new(@login.dup)

      @api_username = "lumberg"
      @park = Cpanel::Park.new(
        :server       => @server.dup,
        :api_username => @api_username
      )
    end

    describe "::api_module" do
      it 'returns "Park"' do
        @park.class::api_module.should == "Park"
      end
    end

    describe "#park" do
      use_vcr_cassette "cpanel/park/park"

      it "requires domain" do
        requires_attr("domain") { @park.park }
      end

      it "creates a new parked domain" do
        result = @park.park(:domain    => "test-park.com")
        result[:params][:data].first[:result].should == 1
      end
    end

    describe "#unpark" do
      use_vcr_cassette "cpanel/park/unpark"

      it "requires domain" do
        requires_attr("domain") { @park.unpark }
      end

      it "removes a parked domain" do
        result = @park.unpark(:domain => "test-park.com")
        result[:params][:data].first[:result].should == 1
      end
    end

    describe "#listparkeddomains" do
      use_vcr_cassette "cpanel/park/listparkeddomains"

      context "parked domains exist on the account" do
        let(:result) { @park.listparkeddomains }
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
          @park.listparkeddomains[:params][:data].should be_empty
        end
      end
    end

    describe "#listaddondomains" do
      use_vcr_cassette "cpanel/park/listaddondomains"

      context "addon domains exist on the account" do
        let(:result) { @park.listaddondomains }
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
          @park.listaddondomains[:params][:data].should be_empty
        end
      end
    end
  end
end
