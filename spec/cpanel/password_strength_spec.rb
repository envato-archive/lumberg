require "spec_helper"

module Lumberg
  describe Cpanel::PasswordStrength do
    let(:server) { Whm::Server.new(:host => @whm_host, :hash => @whm_hash) }
    let(:api_username) { "lumberg" }
    let(:password_strength) do
      described_class.new(
        :server       => server,
        :api_username => api_username
      )
    end

    let(:weak_password) { "weakness" }
    let(:strong_password) { "0zUIcv-0" }

    describe "#strength" do
      use_vcr_cassette "cpanel/password_strength/strength"

      it "tests a weak password" do
        result = password_strength.strength( :password => weak_password )
        result[:params][:data][0][:strength].should be_an(Integer)
      end

      it "tests a strong password" do
        result = password_strength.strength( :password => strong_password )
        result[:params][:data][0][:strength].should be_an(Integer)
      end
    end

    describe "#required_strength" do
      use_vcr_cassette "cpanel/password_strength/required_strength"

      it "gets required password strength for a specific app" do
        result = password_strength.required_strength( :app => 'htaccess' )
        result[:params][:data][0][:strength].should be_an(Integer)
      end
    end

    describe "#all_required_strengths" do
      use_vcr_cassette "cpanel/password_strength/all_required_strengths"

      it "gets required password strengths for all apps" do
        result = password_strength.all_required_strengths
        result[:params][:data][0].should be_a(Hash)
      end
    end
  end
end

