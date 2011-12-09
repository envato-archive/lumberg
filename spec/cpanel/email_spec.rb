require 'spec_helper'
require 'lumberg/whm'
require 'lumberg/cpanel'

module Lumberg
  describe Cpanel::Email do
    before(:each) do
      @login  = { :host => @whm_host, :hash => @whm_hash }
      @server = Whm::Server.new(@login.dup)

      @api_username = "lumberg"
      @email = Cpanel::Email.new(
        :server       => @server.dup,
        :api_username => @api_username
      )
    end

    describe "::api_module" do
      subject { @email.class::api_module }
      it { should == "Email" }
    end

    describe "#mailing_lists" do
      use_vcr_cassette "cpanel/email/mailing_lists"

      subject { @email.mailing_lists[:params][:data] }
      it { should be_an(Array) }

      it "returns an array with info for each mailing list" do
        subject.each {|info|
          info.keys.should include(
            :humandiskused, :list, :desthost, :diskused, :listid
          )
        }
      end
    end

    describe "#forwarders" do
      use_vcr_cassette "cpanel/email/forwarders"

      subject { @email.forwarders[:params][:data] }
      it { should be_an(Array) }

      it "returns an array with info for each forwarder" do
        subject.each {|info|
          info.keys.should include(
            :uri_dest, :forward, :html_dest, :uri_forward, :dest, :html_forward
          )
        }
      end
    end

    describe "#accounts" do
      use_vcr_cassette "cpanel/email/accounts"

      subject { @email.accounts[:params][:data] }
      it { should be_an(Array) }

      it "returns an array with info for each email account" do
        subject.each {|info|
          info.keys.should include(
            :txtdiskquota, :diskquota, :diskusedpercent, :diskused,
            :humandiskquota, :_diskused, :login, :email, :domain, :user,
            :humandiskused, :diskusedpercent20, :_diskquota
          )
        }
      end
    end

    describe "#accounts_" do
      use_vcr_cassette "cpanel/email/accounts_"

      subject { @email.accounts_[:params][:data] }
      it { should be_an(Array) }

      it "returns an array with info for each email account" do
        subject.each {|info| info.keys.should include(:login, :email) }
      end
    end
  end
end
