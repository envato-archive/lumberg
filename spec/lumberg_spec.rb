require 'spec_helper'

describe Lumberg do
  it "should have a version" do
    Lumberg::VERSION.should match /\d+/
  end
end
