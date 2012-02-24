require 'logging'

module Lumberg
  module Logger
    @@logger = Logging.logger(STDOUT)
    
    class << self
      def add(message, method = :info)
        @@logger.send(method, message)
      end
    
      def switch_to(output)
        @@logger = Logging.logger(output)
      end
    end
  end
end
