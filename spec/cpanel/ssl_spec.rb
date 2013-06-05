require "spec_helper"


module Lumberg
  describe Cpanel::Ssl do
    let(:domain) { "lumberg-test.com" }
    let(:server) { Whm::Server.new(:host => @whm_host, :hash => @whm_hash) }
    let(:api_username) { "lumberg" }

    CP_CERT = File.read('./spec/sample_certs/cpanel.crt')
    CP_KEY = File.read('./spec/sample_certs/cpanel.key')

    let(:cert_params) {{ :user => :api_username, :city => "Chicago", :company => "Initech",
                           :companydivision => "TPS", :country => "US", :state => "IL",
                           :email => "lumberg@initech.com", :host => domain,
                           :pass => "Tru3St0ry", :key => CP_KEY}}

    let(:ssl) do
      described_class.new(
        :server       => server,
        :api_username => api_username
      )
    end

    describe "#installssl" do
      use_vcr_cassette("cpanel/ssl/installssl")

      it "installs a certificate for a cPanel account" do
        ssl.installssl(:user => :api_username, :crt => CP_CERT,
          :domain => domain, :key => CP_KEY)[:params][:data][0][:result].should eq(1)
      end
    end

    describe "#listcsrs" do
      use_vcr_cassette("cpanel/ssl/listcsrs")

      it "prints the csrs for a cPanel account" do
        ssl.listcsrs(:user => :api_username
          )[:params][:data][0][:host].should == domain
      end
    end

    describe "#showcsr" do
      use_vcr_cassette("cpanel/ssl/showcsr")

      it "prints the current csr for a domain" do
        ssl.showcsr(:user => :api_username, :domain => domain, :textmode => 0
          )[:params].to_s.should =~ /CERTIFICATE REQUEST/
      end
    end

    describe "#showkey" do
      use_vcr_cassette("cpanel/ssl/showkey")

      it "prints the current key for a domain" do
        ssl.showkey(:user => :api_username, :domain => domain, :textmode => 0
          )[:params].to_s.should =~ /PRIVATE KEY/
      end
    end

    describe "#showcrt" do
      use_vcr_cassette("cpanel/ssl/showcrt")

      it "prints the current cert for a domain" do
        ssl.showcrt(:user => :api_username, :domain => domain, :textmode => 0
          )[:params].to_s.should =~ /BEGIN CERTIFICATE/
      end
    end

    describe "#listcrts" do
      use_vcr_cassette("cpanel/ssl/listcrts")

      it "lists the certs installed for an account " do
        ssl.listcrts(:user => :api_username)[:params][:data][0][:ssltxt].to_s.should \
           =~ /Certificate/
      end
    end

    describe "#listkeys" do
      use_vcr_cassette("cpanel/ssl/listkeys")

      it "lists the keys installed for an account" do
        ssl.listkeys(:user => :api_username)[:params][:data][0][:host].should == domain
      end
    end

    describe "#fetchcabundle" do
      use_vcr_cassette("cpanel/ssl/fetchcabundle")

      it "fetches the CA bundle tied to the cert if any exist" do
        ssl.listsslitems(:crt => CP_CERT)[:params][:event][:result].should eq(1)
      end
    end

    describe "#listsslitems" do
      use_vcr_cassette("cpanel/ssl/listsslitems")

      it "lists keys for a domain" do
        ssl.listsslitems(:domains => domain, :items => 'key')[:params][:data][0][:host].should \
          == domain
      end
    end

    describe "#gencsr" do
      use_vcr_cassette("cpanel/ssl/gencsr")

      it "generates a certificate signing request" do
        ssl.gencsr(cert_params)[:params][:data][0][:result].should eq(1)
      end
    end

    describe "#gencrt" do
      use_vcr_cassette("cpanel/ssl/gencrt")

      it "generates a certificate" do
        ssl.gencrt(cert_params.merge(:key => CP_KEY))[:params][:data][0][:result].should eq(1)
      end
    end

    describe "#genkey" do
      use_vcr_cassette("cpanel/ssl/genkey")

      it "generates a key" do
        ssl.genkey(:user => api_username, :host => domain, :keysize => 2048
          )[:params][:data][0][:result].should eq(1)
      end
    end

    describe "#uploadcrt" do
      use_vcr_cassette("cpanel/ssl/uploadcrt")

      it "uploads a certificate " do
        ssl.uploadcrt(:user => api_username, :crt => CP_CERT,
          :host => domain)[:params][:data][0][:result].should eq(1)
      end
    end
  end
end
