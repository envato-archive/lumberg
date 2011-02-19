require 'spec_helper'
require 'lumberg/whm'

describe Whm do
  before(:each) do
    @host = 'example.com'
  end
  context "Formatting a URL" do
    it "should be a URL" do
      Whm::format_url(@host).should == "https://example.com:2087/json-api/"
    end

    it "should be an SSL URL" do
      Whm::format_url(@host, ssl: false).should == "http://example.com:2086/json-api/"
    end

    it "should transform the host into an SSL URL by default" do
      Whm::format_url(@host).should == "https://example.com:2087/json-api/"
    end

    it "should transform the host into an SSL URL when asked" do
      Whm::format_url(@host, ssl: true).should == "https://example.com:2087/json-api/"
    end

    it "should transform the host into a non SSL URL when asked" do
      Whm::format_url(@host, ssl: false).should == "http://example.com:2086/json-api/"
    end
  end
end
