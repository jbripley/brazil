module Brazil
  class Error < RuntimeError; end
  
  class NoVersionTableException < Error; end
  class UnknowStateException < Error; end
  class NoDbInstanceException < Error; end
end
