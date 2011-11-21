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

    describe "#listsubdomains" do
      use_vcr_cassette "cpanel/sub_domain/listsubdomains"

      context "subdomains exist on the account" do
        let(:result) { @subd.listsubdomains }
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
          @subd.listsubdomains[:params][:data].should be_empty
        end

      end
    end

    describe "#delsubdomain" do
      use_vcr_cassette "cpanel/sub_domain/delsubdomain"

      it "requires domain" do
        requires_attr("domain") { @subd.delsubdomain }
      end

      it "removes a subdomain" do
        # Add the subdomain first
        @subd.addsubdomain(:domain => "foo", :rootdomain => "lumberg-test.com")

        result = @subd.delsubdomain(:domain => "foo.lumberg-test.com")
        result[:params][:data][0][:result].should == 1
      end
    end

    describe "#addsubdomain" do
      use_vcr_cassette "cpanel/sub_domain/addsubdomain"

      it "requires domain" do
        requires_attr("domain") {
          @subd.addsubdomain(:rootdomain => "domain.com")
        }
      end

      it "requires rootdomain" do
        requires_attr("rootdomain") {
          @subd.addsubdomain(:domain => "sub")
        }
      end

      #it "accepts optional dir" do
      #  accepts_attr("dir") {
      #    @subd.addsubdomain(
      #      :domain     => "sub",
      #      :rootdomain => "domain.com",
      #      :dir        => "public_html/dir"
      #    )
      #  }
      #end

      #it "accepts optional disallowdot" do
      #  accepts_attr("disallowdot") {
      #    @subd.addsubdomain(
      #      :domain      => "sub",
      #      :rootdomain  => "domain.com",
      #      :disallowdot => 1
      #    )
      #  }
      #end

      it "adds a subdomain" do
        # Delete the subdomain first
        @subd.delsubdomain(:domain => "sub.lumberg-test.com")

        result = @subd.addsubdomain(
          :domain     => "sub",
          :rootdomain => "lumberg-test.com"
        )
        result[:params][:data][0][:result].should == 1
      end
    end
  end
end
