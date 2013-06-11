require "spec_helper"

module Lumberg
  describe Cpanel::FileManager do
    let(:server) { Whm::Server.new(:host => @whm_host, :hash => @whm_hash) }
    let(:api_username) { "lumberg" }
    let(:file_manager) do
      described_class.new(
        :server       => server,
        :api_username => api_username
      )
    end

    let(:wanted_file) { '.lastlogin' }

    describe "#list" do
      use_vcr_cassette "cpanel/file_manager/list"

      subject { file_manager.list[:params][:data] }

      it "lists home directory contents" do
        should be_an(Array)
      end
    end

    describe "#show" do
      use_vcr_cassette "cpanel/file_manager/show"

      it "gets information about files and directories" do
        result = file_manager.show({ :file => wanted_file })
        result[:params][:data][0][:file].should === wanted_file
      end
    end

    describe "#stat" do
      use_vcr_cassette "cpanel/file_manager/stat"

      it "gets system information about files" do
        result = file_manager.stat({ :file => wanted_file })
        result[:params][:data][0][:user].should === api_username
      end
    end

    describe "#disk_usage" do
      use_vcr_cassette "cpanel/file_manager/disk_usage"

      it "shows disk usage" do
        result = file_manager.disk_usage
        result[:params][:data][0][:spaceused].to_i.should > 0
      end
    end
  end
end
