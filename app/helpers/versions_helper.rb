require 'dbi'

module VersionsHelper
  def version_testable(version)
    version.created?
  end
  alias :version_created :version_testable
  
  def version_rollbackable(version)
    version.tested?
  end
  alias :version_tested :version_rollbackable
  
  def sql_escape(object)
    escaped_object = DBI::TypeUtil.convert(nil, object)
    if escaped_object
      escaped_object
    else
      "NULL"
    end
  end
end
