require 'spec_helper'

module Lumberg
  describe "Lumberg::VERSION" do
    it "has a valid format" do
      VERSION.should match /\d+/
    end
  end
end
