require "spec_helper"

module Lumberg
  describe Cpanel::Branding do
    let(:server) { Whm::Server.new(:host => @whm_host, :hash => @whm_hash) }
    let(:api_username) { "lumberg" }
    let(:branding) do
      described_class.new(
        :server       => server,
        :api_username => api_username
      )
    end

    subject { branding }

    describe "::api_module" do
      subject { described_class::api_module }

      it { should == "Branding" }
    end

    describe "#list_pkgs" do
      use_vcr_cassette("cpanel/branding/list_pkgs")

      its(:list_pkgs) { should return_a_list }
    end

    describe "#list_sprites" do
      use_vcr_cassette("cpanel/branding/list_sprites")

      its(:list_sprites) { should return_a_list }
    end

    describe "#list_icons" do
      use_vcr_cassette("cpanel/branding/list_icons")

      its(:list_icons) { should return_a_list }
    end

    describe "#list_object_types" do
      use_vcr_cassette("cpanel/branding/list_object_types")

      its(:list_object_types) { should return_a_list }
    end

    describe "#list_image_types" do
      use_vcr_cassette("cpanel/branding/list_image_types")

      its(:list_image_types) { should return_a_list }
    end
  end
end
