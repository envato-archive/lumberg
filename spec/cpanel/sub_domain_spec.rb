require 'spec_helper'
require 'lumberg/whm'
require 'lumberg/cpanel'

module Lumberg
  describe Cpanel::SubDomain do
    before(:each) do
      @login    = { :host => @whm_host, :hash => @whm_hash }
      @server   = Whm::Server.new(@login.dup)

      @api_username = "lumberg"
      @subd = Cpanel::SubDomain.new(
        :server       => @server.dup,
        :api_username => @api_username
      )
    end

    describe "::api_module" do
      it 'returns "SubDomain"' do
        @subd.class::api_module.should == "SubDomain"
      end
    end

    describe "#list" do
      use_vcr_cassette "cpanel/sub_domain/list"

      context "subdomains exist on the account" do
        let(:result) { @subd.list }
        subject { result[:params][:data] }

        it "returns an array with info for each subdomain" do
          subject.should be_an(Array)
          subject.each {|info|
            info.keys.should include(
              :domainkey, :status, :reldir, :dir, :subdomain,
              :rootdomain, :domain, :basedir
            )
          }
        end
      end

      context "subdomains do not exist on the account" do
        before { @subd.api_username = "minimal" }
        after { @subd.api_username = "lumberg" }

        it "returns an empty array" do
          @subd.list[:params][:data].should be_empty
        end

      end
    end

    describe "#remove" do
      use_vcr_cassette "cpanel/sub_domain/remove"

      it "removes a subdomain" do
        # Add the subdomain first
        @subd.add(:domain => "foo", :rootdomain => "lumberg-test.com")

        result = @subd.remove(:domain => "foo.lumberg-test.com")
        result[:params][:data][0][:result].should == 1
      end
    end

    describe "#add" do
      use_vcr_cassette "cpanel/sub_domain/add"

      it "adds a subdomain" do
        # Delete the subdomain first
        @subd.remove(:domain => "sub.lumberg-test.com")

        result = @subd.add(
          :domain     => "sub",
          :rootdomain => "lumberg-test.com"
        )
        result[:params][:data][0][:result].should == 1
      end
    end
  end
end
