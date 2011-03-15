module Net
  class HTTP
    @skip_bad_headers = false

    class << self
      def skip_bad_headers
        @skip_bad_headers
      end

      def skip_bad_headers=(value)
        @skip_bad_headers = value
      end
    end
  end

  class << HTTPResponse
    def each_response_header(sock)
      key = value = nil
      while true
        line = sock.readuntil("\n", true).sub(/\s+\z/, '')
        break if line.empty?
        if line[0] == ?\s or line[0] == ?\t and value
          value << ' ' unless value.empty?
          value << line.strip
        else
          yield key, value if key
          key, value = line.strip.split(/\s*:\s*/, 2)
          next if value.nil? && Net::HTTP.skip_bad_headers
          raise HTTPBadResponse, 'wrong header line format' if value.nil?
        end
      end
      yield key, value if key
    end
  end
end
