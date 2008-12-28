module Brazil
  class Error < RuntimeError; end
  
  class UnknowStateException < Error; end
  class LoadException < Error; end

  class NoDBInstanceException < Error; end

  class DBException < Error; end
  class DBConnectionException < DBException; end
  class DBExecuteSQLException < DBException; end
  class UnknownDBTypeException < DBException; end
  class NoVersionTableException < DBException; end
end
