# encoding: utf-8
require "spec_helper"

describe Lumberg::FormatWhm do
  subject { described_class.new({ }, :query, "data") }

  context "gzip" do
    let(:gzipped_data) do
      "\x1F\x8B\b\x00\x13d\x01V\x00\x03\xABV*.MNN-.V\xB2*)*M\xD5Q\xCA" +
      "\x05\xB2\x13\xD3S\x95\xAC\x94\x8A\xF3sS\x15R\x12K\x12\x95j\x01" +
      "\xA0E\x91\xF9&\x00\x00\x00"
    end

    it "removes content encoding" do
      env = { body: gzipped_data,
              response_headers: { "content-encoding" => "gzip" } }

      subject.on_complete(env)

      env.should_not include "content-encoding"

      env[:body][:params][:message].should eq "some data"
    end
  end

  context "deflate" do
    let(:compressed_data) do
      "x\x9C\xABV*.MNN-.V\xB2*)*M\xD5Q\xCA\x05\xB2\x13\xD3S\x95\xAC" +
      "\x94\x8A\xF3sS\x15R\x12K\x12\x95j\x01\n\xFE\rq"
    end

    it "removes content encoding" do
      env = { body: compressed_data,
              response_headers: { "content-encoding" => "deflate" } }

      subject.on_complete(env)

      env.should_not include "content-encoding"

      env[:body][:params][:message].should eq "some data"
    end
  end

  context "no content encoding" do
    it "doesn't touch response headers" do
      env = { body: "{\"success\":true,\"message\":\"some data\"}",
              response_headers: { foo: "bar" } }

      subject.on_complete(env)

      env[:response_headers].should include :foo

      env[:body][:params][:message].should eq "some data"
    end
  end

  context "API unavailable" do
    it "raises a Lumberg::WhmConnectionError" do
      env = { body: "cPanel operations have been temporarily suspended", response_headers: { foo: "bar" } }

      expect { subject.on_complete(env) }.to raise_error(Lumberg::WhmConnectionError)
    end
  end
end
