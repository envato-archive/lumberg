require 'spec_helper'
require 'lumberg/whm'

describe Whm do
  context "Formatting a URL" do
    it "should be a URL" do
      Whm::format_url("example.com").should == "https://example.com:2087/json-api/"
    end

    it "should be an SSL URL" do
      Whm::format_url("example.com", :ssl => false).should == "http://example.com:2086/json-api/"
    end
  end
end
