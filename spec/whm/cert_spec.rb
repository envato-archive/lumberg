require 'spec_helper'
require 'lumberg/whm'
CERT = File.read('./spec/sample_certs/main.crt')
SELF_CERT = File.read('./spec/sample_certs/sample.crt')
SELF_KEY = File.read('./spec/sample_certs/sample.key')

module Lumberg
  describe Whm::Cert do
    before(:each) do
      @login    = { :host => @whm_host, :hash => @whm_hash }
      @server   = Whm::Server.new(@login.dup)
      @cert      = Whm::Cert.new(:server => @server.dup)
    end

    describe "#listcrts" do
      use_vcr_cassette "whm/cert/listcrts"

      it "lists installed certificates" do
        result = @cert.listcrts
        result[:success].should be_true
        result[:message].should be_true
      end
    end

    describe "#fetchsslinfo" do
      use_vcr_cassette "whm/cert/fetchsslinfo"

      it "displays the SSL certificate, private key, and CA bundle/intermediate certificate associated with a specified domain" do
        result = @cert.fetchsslinfo(:domain => "myhost.com", :crtdata => CERT)
        result[:success].should be_true
        result[:message].should match("ok")
        result[:params][:crt].should match(/.*BEGIN CERTIFICATE.*/)
        result[:params][:key].should match(/.*KEY.*/)
      end
    end

    describe "#generatessl" do
      use_vcr_cassette "whm/cert/generatessl"

      it "generates a CSR" do
        result = @cert.generatessl(:city => "houston", :xemail => "test@myhost.com", :host => "myhost.com", 
                                   :country => "US", :state => "TX", :co => "Company", :cod => "Dept", 
                                   :email => "test@myhost.com", :pass => "abc123")
        result[:success].should be_true
        result[:message].should == "Key, Certificate, and CSR generated OK"
        result[:params][:csr].should match(/.*BEGIN CERTIFICATE REQUEST.*/)
        result[:params][:cert].should match(/.*BEGIN CERTIFICATE.*/)
        result[:params][:key].should match(/.*BEGIN RSA PRIVATE KEY.*/)
      end
    end

    describe "#installssl" do
      use_vcr_cassette "whm/cert/installssl"

      it "installs a certificate" do
        result = @cert.installssl(:domain => 'check.com', :user => "nobody", :cert => SELF_CERT, :key => SELF_KEY, :ip => '192.1.2.3')
        result[:success].should be_true
        result[:message].should match(/Certificate successfully installed/)
      end
    end
  end
end
