require 'spec_helper'

module Lumberg
  describe "VERSION" do
    it "has a valid format" do
      VERSION.should match /\d+/
    end
  end
end
