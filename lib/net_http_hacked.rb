module Net
  class HTTP
    @skip_bad_headers = false

    class << self
      # Accessor for @skip_bad_headers
      def skip_bad_headers
        @skip_bad_headers
      end

      # Mutator for @skip_bad_headers
      def skip_bad_headers=(value)
        @skip_bad_headers = value
      end
    end
  end

  class << HTTPResponse
    # Parses each response header and strips out bad headers if skip_bad_headers is set
    def each_response_header(sock)
      key = value = nil
      while true
        line = sock.readuntil("\n", true).sub(/\s+\z/, '')
        break if line.empty?
        if line[0] == ?\s or line[0] == ?\t and value
          value << ' ' unless value.empty?
          value << line.strip
        else
          tmp_key, tmp_value = line.strip.split(/\s*:\s*/, 2)
          next if tmp_value.nil? && Net::HTTP.skip_bad_headers

          yield key, value if key

          key   = tmp_key
          value = tmp_value
          raise HTTPBadResponse, 'wrong header line format' if value.nil?
        end
      end
      yield key, value if key
    end
  end
end
