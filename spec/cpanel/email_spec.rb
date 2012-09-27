require "spec_helper"

module Lumberg
  describe Cpanel::Email do
    let(:domain) { "lumberg-test.com" }
    let(:server) { Whm::Server.new(:host => @whm_host, :hash => @whm_hash) }
    let(:api_username) { "lumberg" }
    let(:email) do
      described_class.new(
        :server       => server,
        :api_username => api_username
      )
    end

    describe "::api_module" do
      subject { email.class::api_module }

      it { should == "Email" }
    end

    describe "#add_mailing_list" do
      use_vcr_cassette("cpanel/email/add_mailing_list")

      it "adds a mailing list" do
        email.add_mailing_list(
          :list     => "add-test", 
          :domain   => domain,
          :password => "s3cr3t5" 
        )

        email.mailing_lists[:params][:data].find {|l|
          l[:list] == "add-test@#{domain}"
        }.should_not be_nil
      end
    end

    describe "#mailing_lists" do
      use_vcr_cassette("cpanel/email/mailing_lists")

      before do
        email.add_mailing_list(
          :list     => "test-list", 
          :domain   => domain,
          :password => "s3cr3t5" 
        )
      end

      it "returns a list of mailing lists" do 
        email.mailing_lists[:params][:data].find {|l|
          l[:list] == "test-list@#{domain}"
        }.should_not be_nil
      end
    end

    describe "#add_forwarder" do
      let(:local) { "fwd-test" }

      use_vcr_cassette("cpanel/email/add_forwarder")

      it "raises if fwdopt is invalid" do
        expect {
          email.add_forwarder(:fwdopt => :invalid)
        }.to raise_error
      end

      it "adds a forwarder" do
        email.add_forwarder(
          :domain   => domain,
          :email    => local,
          :fwdopt   => :fwd,
          :fwdemail => "foo@bar.com"
        )

        email.forwarders[:params][:data].find {|f|
          f[:dest] == "#{local}@#{domain}"
        }.should_not be_nil
      end
    end

    describe "#forwarders" do
      let(:local) { "test-fwd" }

      use_vcr_cassette("cpanel/email/forwarders")

      before do
        email.add_forwarder(
          :domain   => domain,
          :email    => local,
          :fwdopt   => :fwd,
          :fwdemail => "foo@bar.com"
        )
      end

      it "returns a list of forwarders" do
        email.forwarders[:params][:data].find {|f|
          f[:dest] == "#{local}@#{domain}"
        }.should_not be_nil
      end
    end

    describe "#add_account" do
      let(:local) { "account-test" }

      use_vcr_cassette("cpanel/email/add_account")

      it "adds an email account" do
        email.add_account(
          :domain   => domain,
          :email    => local,
          :password => "magicpants",
          :quota    => 0
        )

        email.accounts[:params][:data].find {|a|
          a[:email] == "#{local}@#{domain}"
        }.should_not be_nil
      end
    end

    describe "account list methods" do
      let(:local) { "test-account" }

      use_vcr_cassette("cpanel/email/accounts")

      before(:each) do
        email.add_account(
          :domain   => domain,
          :email    => local,
          :password => "sauce",
          :quota    => 0
        )
      end

      describe "#accounts" do
        it "returns a list of email accounts" do
          email.accounts[:params][:data].find {|a|
            a[:email] == "#{local}@#{domain}"
          }.should_not be_nil
        end
      end

      describe "#accounts_" do
        it "returns a list of email accounts" do
          email.accounts_[:params][:data].find {|a|
            a[:email] == "#{local}@#{domain}"
          }.should_not be_nil
        end
      end

      describe "#accounts_with_image" do
        it "returns a list of email accounts" do
          email.accounts_with_image[:params][:data].find {|a|
            a[:email] == "#{local}@#{domain}"
          }.should_not be_nil
        end
      end
    end

    #describe "#domains" do
    #  use_vcr_cassette "cpanel/email/domains"

    #  subject { @email.domains[:params][:data] }
    #  it { should be_an(Array) }

    #  it "returns an array with info for each domain" do
    #    subject.each {|info| info.keys.should include(:domain) }
    #  end
    #end

    #describe "#mx" do
    #  use_vcr_cassette "cpanel/email/mx"

    #  subject { @email.mx(:domain => domain)[:params][:data] }
    #  it { should be_an(Array) }

    #  it "returns an array with info for each mail exchanger" do
    #    #puts YAML.dump(subject)
    #    subject.each {|info|
    #      info.keys.should include(
    #        :mxcheck, :entries, :statusmsg, :detected, :secondary, :remote,
    #        :status, :alwaysaccept, :mx, :domain, :local
    #      )

    #      info[:entries].each {|entry|
    #        entry.keys.should include(
    #          :priority, :mx, :domain, :entrycount, :row
    #        )
    #      }
    #    }
    #  end
    #end

    #describe "#set_mail_delivery" do
    #  use_vcr_cassette("cpanel/email/set_mail_delivery")

    #  it "should raise an error if given an invalid delivery option" do
    #    expect {
    #      email.set_mail_delivery(
    #        :domain   => domain,
    #        :delivery => :invalid
    #      )
    #    }.to raise_error("Invalid :delivery option")
    #  end

    #  context "remote delivery" do
    #    subject {
    #      email.set_mail_delivery(
    #        :domain   => domain,
    #        :delivery => "remote"
    #      )[:params][:data].first
    #    }

    #    it { should be_a(Hash) }

    #    its([:mxcheck])   { should == "remote" }
    #    its([:secondary]) { should == 0 }
    #    its([:remote])    { should == 1 }
    #    its([:local])     { should == 0 }

    #    it "returns info for the mail exchanger" do
    #      subject.keys.should include(
    #        :mxcheck, :statusmsg, :checkmx, :detected, :results,
    #        :secondary, :remote, :status, :local
    #      )
    #    end
    #  end

    #  context "local delivery" do
    #    subject {
    #      @email.set_mail_delivery(
    #        :domain   => domain,
    #        :delivery => "local"
    #      )[:params][:data].first
    #    }

    #    it { should be_a(Hash) }
    #    its([:mxcheck])   { should == "local" }
    #    its([:secondary]) { should == 0 }
    #    its([:remote])    { should == 0 }
    #    its([:local])     { should == 1 }

    #    it "returns info for the mail exchanger" do
    #      subject.keys.should include(
    #        :mxcheck, :statusmsg, :checkmx, :detected, :results,
    #        :secondary, :remote, :status, :local
    #      )
    #    end
    #  end
    #end

  end
end
