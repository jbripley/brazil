module Brazil
module VersionControl
  TYPE_SUBVERSION = :svn

  REVISION_TYPE_TAG = :tag
  REVISION_TYPE_BRANCH = :branch
  REVISION_TYPE_TRUNK = :trunk

  def new(vc_type, repository_uri, username, password)
    if repository_uri.nil? || repository_uri.strip == ''
      raise Brazil::VersionControlException, 'You must supply a repository URI'
    end

    case vc_type.to_sym
      when TYPE_SUBVERSION
        begin
          require 'brazil/version_control/svn_ruby'
          return Brazil::VersionControl::SVNRuby.new(repository_uri, username, password)
        rescue LoadError
          begin
            require 'brazil/version_control/svn_java'
            return Brazil::VersionControl::SVNJava.new(repository_uri, username, password)
          rescue LoadError
            raise Brazil::VersionControlException, 'No required subversion binding installed'
          end
        end
      else
        raise Brazil::VersionControlException, "No VersionControl type implementation for URI: #{repository_uri}"
    end
  end
  module_function :new

  class VersionControl
    attr_reader :repository_uri, :username

    protected

    def initialize(repository_uri, username, password)
      @repository_uri = repository_uri
      @username = username
      @password = password
    end

    def to_s
      return "#{@username}@#{@repository_uri}"
    end

    def cat(relative_repos_path, vc_revision=nil)
      raise NotImplementedError
    end

    def list(relative_repos_path, vc_revision=nil, recurse=false, &block) # :yields: VersionControlPath
      raise NotImplementedError
    end

    def tag(vc_revision, commit_message='')
      raise NotImplementedError
    end

    def list_tags() # :yields: VersionControlRevision
      raise NotImplementedError
    end

    def branch(vc_revision, commit_message='')
      raise NotImplementedError
    end

    def list_branches() # :yields: VersionControlRevision
      raise NotImplementedError
    end

    def checkout(checkout_path, vc_revision=nil)
      raise NotImplementedError
    end

    def export(export_path, vc_revision=nil)
      raise NotImplementedError
    end

    def update(update_path)
      raise NotImplementedError
    end

    def get_property(relative_repos_path, property_name, vc_revision=nil)
      raise NotImplementedError
    end

    def set_property(relative_repos_path, property_name, property_value, vc_revision=nil)
      raise NotImplementedError
    end

    def mkdir(working_copy_path)
      raise NotImplementedError
    end

    def valid_credentials?
      raise NotImplementedError
    end

  end
end
end