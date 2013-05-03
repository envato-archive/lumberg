module Lumberg
  # Raises Lumberg::WhmArgumentError when an argument is invalid or missing
  class WhmArgumentError < ArgumentError; end
  # Raises Lumberg::WhmInvalidUser when request is performed on an invalid user
  class WhmInvalidUser < RuntimeError; end
end
