module Brazil
  class Error < RuntimeError; end

  class UnknowStateException < Error; end
  class LoadException < Error; end

  class DBException < Error; end
  class NoDBInstanceException < DBException; end
  class DBConnectionException < DBException; end
  class DBExecuteSQLException < DBException; end
  class UnknownDBTypeException < DBException; end
  class NoVersionTableException < DBException; end

  class VersionControlException < Error; end
end
