module Lumberg
  # WHM Exception for when an argument is invalid, missing, etc.
  class WhmArgumentError < ArgumentError; end
  # WHM Exception for when a request is performed on an invalid user
  class WhmInvalidUser < RuntimeError; end
end
