require "spec_helper"

module Lumberg
  describe Cpanel::Cron do
    let(:server) { Whm::Server.new(:host => @whm_host, :hash => @whm_hash) }
    let(:api_username) { "lumberg" }
    let(:cron) do
      described_class.new(
        :server       => server,
        :api_username => api_username
      )
    end

    describe "#set_email" do
      let(:email) { "sauron@mordor.com" }

      use_vcr_cassette("cpanel/cron/set_email")

      it "sets cron notification email address" do
        cron.set_email(:email => email)
        cron.email[:params][:data][0][:email].should == email
      end
    end

    describe "#email" do
      let(:email) { "sauron@mordor.com" }

      use_vcr_cassette("cpanel/cron/email")

      before { cron.set_email(:email => email) }

      it "gets cron notification email address" do
        cron.email[:params][:data][0][:email].should == email
      end
    end

    describe "#list" do
      let(:command) { "hi" }

      use_vcr_cassette("cpanel/cron/list")

      before do
        cron.add(
          :command => command,
          :minute  => 1,
          :hour    => 1,
          :day     => 1,
          :month   => 1,
          :weekday => 1
        )
      end

      it "retrieves a list of crontab entries" do
        cron.list[:params][:data].find {|e|
          e[:command] == command
        }.should include(
          :command => command,
          :minute  => "1",
          :hour    => "1",
          :day     => "1",
          :month   => "1",
          :weekday => "1"
        )
      end
    end

    describe "#add" do
      let(:command) { "foo" }

      use_vcr_cassette("cpanel/cron/add")

      it "adds a crontab entry" do
        cron.add(
          :command => command,
          :minute  => 1,
          :hour    => 1,
          :day     => 1,
          :month   => 1,
          :weekday => 1
        )

        cron.list[:params][:data].find {|e|
          e[:command] == command
        }.should include(
          :command => command,
          :minute  => "1",
          :hour    => "1",
          :day     => "1",
          :month   => "1",
          :weekday => "1"
        )
      end
    end

    describe "#remove" do
      let(:command) { "baz" }
      let(:linekey) do
        cron.list[:params][:data].find {|e|
          e[:command] == command
        }[:linekey]
      end

      use_vcr_cassette("cpanel/cron/remove")

      before do
        cron.add(
          :command => command,
          :minute  => 1,
          :hour    => 1,
          :day     => 1,
          :month   => 1,
          :weekday => 1
        )

        cron.remove(:linekey => linekey)
      end

      it "removes a crontab entry" do
        cron.list[:params][:data].find {|e|
          e[:linekey] == linekey
        }.should be_nil
      end
    end

    describe "#edit" do
      let(:command) { "whatev" }

      use_vcr_cassette("cpanel/cron/edit")

      before do
        @linekey = cron.add(
          :command => command,
          :minute  => 1,
          :hour    => 1,
          :day     => 1,
          :month   => 1,
          :weekday => 1
        )[:params][:data][0][:linekey]
      end

      it "edits a crontab entry" do
        @linekey = cron.edit(
          :linekey => @linekey,
          :command => "taco",
          :day     => 1,
          :hour    => 3,
          :minute  => 1,
          :month   => 1,
          :weekday => 1
        )[:params][:data][0][:linekey]

        cron.list[:params][:data].find {|e|
          e[:linekey] == @linekey
        }.should include(
          :command => "taco",
          :hour    => "3"
        )
      end
    end
  end
end
