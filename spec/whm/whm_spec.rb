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

  context "Formatting the Hash" do
    it "should raise an error if hash is not a string" do
      expect{ Whm::format_hash(nil)}.to raise_error(Lumberg::WhmArgumentError, "Missing WHM hash")
    end

    it "should remove \\n's from the hash" do
      hash = Whm::format_hash("my\nhash\n")
      hash.should == 'myhash'
    end

    it "should remove whitespace from the hash" do
      hash = Whm::format_hash("    my hash ")
      hash.should == 'myhash'
    end
  end
end
