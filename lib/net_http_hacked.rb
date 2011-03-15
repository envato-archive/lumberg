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
          if value.nil? 
            if Net::HTTP.skip_bad_headers
              value = ' '
            else
              raise HTTPBadResponse, 'wrong header line format'
            end
          end
        end
      end
      yield key, value if key
    end
  end
end
