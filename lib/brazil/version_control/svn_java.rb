require 'brazil/version_control/svn_generic'

require 'java'
include_class 'org.tigris.subversion.javahl.SVNClient'
include_class 'org.tigris.subversion.javahl.NodeKind'
include_class 'org.tigris.subversion.javahl.ClientException'

module Brazil::VersionControl
  class SVNJava < SVNGeneric

    def checkout(checkout_path, vc_revision=nil)
      repos_path = make_revision_path(vc_revision)
      begin
        vc_client.checkout(repos_path, checkout_path, nil, true)
      rescue ClientException => svn_exception
        raise Brazil::VersionControlException, "Could not checkout repository: #{@repository_uri} to path: #{checkout_path} (#{svn_exception})", caller
      end
    end

    def export(export_path, vc_revision=nil)
      repos_path = make_revision_path(vc_revision)
      begin
        vc_client.doExport(repos_path, export_path, nil, false)
      rescue ClientException => svn_exception
        raise Brazil::VersionControlException, "Could not export repository: #{@repository_uri} to path: #{export_path} (#{svn_exception})", caller
      end
    end

    def get_property(relative_repos_path, property_name, vc_revision=nil)
      repos_path = make_revision_path(vc_revision, relative_repos_path)
      begin
        property = vc_client.revProperty(repos_path, property_name, nil)
        return {property.getName => property.getValue}
      rescue ClientException => svn_exception
        raise Brazil::VersionControlException, "Could not get property: #{property_name} on url: #{repos_path}@#{rev.to_s} (#{svn_exception})", caller
      end
    end

    def set_property(relative_repos_path, property_name, property_value, vc_revision=nil)
      repos_path = make_revision_path(vc_revision, relative_repos_path)
      begin
        vc_client.setRevProperty(repos_path, property_name, nil, property_value, false)
      rescue ClientException => svn_exception
        raise Brazil::VersionControlException, "Could not set property: #{property_name} on url: #{repos_path}@#{rev.to_s} (#{svn_exception})", caller
      end
    end

    def mkdir(working_copy_path)
      begin
        vc_client.mkdir([working_copy_path], '', true, nil)
      rescue ClientException => svn_exception
        raise Brazil::VersionControlException, "Could not create working copy dir: #{working_copy_path} (#{svn_exception})", caller
      end
    end

    def valid_credentials?
      begin
        vc_client.list(@repository_uri, nil, false)
      rescue ClientException => svn_exception
        return false
      end

      return true
    end

    protected

    def vc_client
      client = SVNClient.new
      client.username(@username)
      client.password(@password)

      return client
    end

    def repos_list(repos_path, recurse, &block) # :yields: VersionControl::Path
      begin
        vc_client.list(repos_path, nil, recurse).each do |dirent|
          vc_path = make_vc_path(repos_path, dirent.getPath, dirent)
          yield vc_path unless vc_path.path == ''
        end
      rescue ClientException => svn_exception
        raise Brazil::VersionControlException, "Could not list: #{repos_path} (#{svn_exception})", caller
      end
    end

    def repos_cat(repos_path)
      begin
        content = java.lang.String.new(vc_client.fileContent(repos_path, nil), 'UTF-8')
        return content.toString()
      rescue ClientException => svn_exception
        raise Brazil::VersionControlException, "Could not cat: #{repos_path}@HEAD (#{svn_exception})", caller
      end
    end

    def repos_copy(vc_revision, commit_message='')
      destination_uri = make_revision_path(vc_revision)

      begin
        vc_client.copy(@repository_uri, destination_uri, commit_message, nil)
      rescue ClientException => svn_exception
        raise Brazil::VersionControlException, "Could not tag/branch: #{vc_revision.id} in module: #{destination_uri} (#{svn_exception})", caller
      end
    end

    def make_vc_path(repository_path, path, dirent)
      vc_path = Path.new
      vc_path.path = path

      vc_path.uri = repository_path
      vc_path.uri += '/' + path unless path == ''

      vc_path.file = (dirent.getNodeKind == NodeKind::file)
      vc_path.directory = (dirent.getNodeKind == NodeKind::dir)
      vc_path.revision = dirent.getLastChangedRevisionNumber
      vc_path.size = dirent.getSize
      vc_path.author = dirent.getLastAuthor
      return vc_path
    end

  end
end