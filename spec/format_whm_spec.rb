# encoding: utf-8
require "spec_helper"

describe Lumberg::FormatWhm do
  subject { described_class.new({ }, :query, "data") }

  context "gzip" do
    let(:gzipped_data) do
      "\u001F\x8B\b\u0000\u001E¹R\u0000\u0003+\xCE\xCFMUHI,I\u0004\u0000" +
      "\u001E\xE9\xC2\xD9\t\u0000\u0000\u0000"
    end

    it "removes content encoding" do
      env = { body: gzipped_data,
              response_headers: { "content-encoding" => "gzip" } }

      subject.on_complete(env)

      env.should_not include "content-encoding"

      env[:body][:params].should eq "some data"
    end
  end

  context "deflate" do
    let(:compressed_data) do
      "x\x9C+\xCE\xCFMUHI,I\x04\x00\x11\x81\x03o"
    end

    it "removes content encoding" do
      env = { body: compressed_data,
              response_headers: { "content-encoding" => "deflate" } }

      subject.on_complete(env)

      env.should_not include "content-encoding"

      env[:body][:params].should eq "some data"
    end
  end

  context "no content encoding" do
    it "doesn't touch response headers" do
      env = { body: "some data", response_headers: { foo: "bar" } }

      subject.on_complete(env)

      env[:response_headers].should include :foo

      env[:body][:params].should eq "some data"
    end
  end
end
