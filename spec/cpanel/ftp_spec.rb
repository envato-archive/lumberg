require "spec_helper"

module Lumberg
  describe Cpanel::Ftp do
    let(:server) { Whm::Server.new(host: @whm_host, hash: @whm_hash) }
    let(:api_username) { "lumberg" }

    let(:ftp) do
      described_class.new(
        server:       server,
        api_username: api_username
      )
    end

    describe "#list_ftp" do
      use_vcr_cassette("cpanel/ftp/listftp")

      it "lists ftp accounts associated to the account" do
        ftp.list_ftp[:params][:data][0][:user].should eq("hello")
      end
    end

    describe "#list_ftp_sessions" do
      use_vcr_cassette("cpanel/ftp/listftpsessions")

      it "lists ftp sessions associated to the account" do
        ftp.list_ftp_sessions[:params][:data][0][:status].should eq("IDLE")
      end
    end

    describe "#list_ftp_with_disk" do
      use_vcr_cassette("cpanel/ftp/listftpwithdisk")

      it "lists ftp accounts with disk information" do
        ftp.list_ftp_with_disk[:params][:data][0][:_diskused].should eq("0")
      end
    end

    describe "#add_ftp" do
      use_vcr_cassette("cpanel/ftp/addftp")

      it "creates the account" do
        ftp.add_ftp(user: 'bob', pass: 'boo')[:params][:data][0][:reason].should eq("OK")
      end
    end

    describe "#passwd" do
      use_vcr_cassette("cpanel/ftp/passwd")

      it "changes the password of the account" do
        ftp.passwd(user: 'bob', pass: 'boo')[:params][:data][0][:reason].should eq("OK")
      end
    end

    describe "#setquota" do
      use_vcr_cassette("cpanel/ftp/setquota")

      it "sets a quota for the account" do
        ftp.set_quota(user: 'bob', quota: '100')[:params][:data][0][:reason].should eq("OK")
      end
    end

    describe "#del_ftp" do
      use_vcr_cassette("cpanel/ftp/delftp")

      it "removes the account" do
        ftp.del_ftp(user: 'bob', destroy: '1')[:params][:data][0][:reason].should eq("OK")
      end
    end
  end
end
