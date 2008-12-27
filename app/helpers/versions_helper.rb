module VersionsHelper
  def version_testable(version)
    (version.state == Version::STATE_CREATED)
  end
  alias :version_created :version_testable
  
  def version_rollbackable(version)
    (version.state == Version::STATE_TESTED)
  end
  alias :version_tested :version_rollbackable
end
