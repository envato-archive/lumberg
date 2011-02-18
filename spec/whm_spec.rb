require 'spec_helper'
require 'lumberg/whm'

describe Whm do
  it "should format a URL" do
    Whm::format_url("example.com").should == "https://example.com:2087"
  end

  it "should format an SSL URL" do
    Whm::format_url("example.com", :ssl => false).should == "http://example.com:2086"
  end
end
