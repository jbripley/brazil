require 'svn/client'
require 'svn/repos'

require 'brazil/version_control/svn_generic'

module Brazil::VersionControl
  class SVNRuby < SVNGeneric

    def checkout(checkout_path, vc_revision=nil)
      repos_path = make_revision_path(vc_revision)
      begin
        vc_client.checkout(repos_path, checkout_path, nil)
      rescue Svn::Error => svn_exception
        raise Brazil::VersionControlException, "Could not checkout repository: #{@repository_uri} to path: #{checkout_path} (#{svn_exception})", caller
      end
    end

    def export(export_path, vc_revision=nil)
      repos_path = make_revision_path(vc_revision)
      begin
        vc_client.export(repos_path, export_path, nil)
      rescue Svn::Error => svn_exception
        raise Brazil::VersionControlException, "Could not export repository: #{@repository_uri} to path: #{export_path} (#{svn_exception})", caller
      end
    end

    def update(working_copy_path)
      begin
        vc_client.update(working_copy_path)
      rescue Svn::Error => svn_exception
        raise Brazil::VersionControlException, "Could not update working copy path: #{working_copy_path} (#{svn_exception})", caller
      end
    end

    def get_property(relative_repos_path, property_name, vc_revision=nil)
      repos_path = make_revision_path(vc_revision, relative_repos_path)
      begin
        return vc_client.revprop_get(property_name, repos_path)
      rescue Svn::Error => svn_exception
        raise Brazil::VersionControlException, "Could not get property: #{property_name} on url: #{repos_path}@#{vc_revision.to_s} (#{svn_exception})", caller
      end
    end

    def set_property(relative_repos_path, property_name, property_value, vc_revision=nil)
      repos_path = make_revision_path(vc_revision, relative_repos_path)
      begin
        vc_client.revprop_set(property_name, property_value, repos_path, nil, false)
      rescue Svn::Error => svn_exception
        raise Brazil::VersionControlException, "Could not set property: #{property_name} on url: #{repos_path}@HEAD (#{svn_exception})", caller
      end
    end

    # TODO: Test implementation
#    def mkdir(working_copy_paths)
#      begin
#        vc_client.mkdir_p(working_copy_path)
#      rescue Svn::Error => svn_exception
#        raise Brazil::VersionControlException, "Could not create working copy dir: #{working_copy_path} (#{svn_exception})", caller
#      end
#    end

    def add(working_copy_paths)
      begin
        vc_client.add(working_copy_paths, true, true)
      rescue Svn::Error => svn_exception
        raise Brazil::VersionControlException, "Could not add working copy path: #{working_copy_paths} (#{svn_exception})", caller
      end
    end

    def commit(working_copy_paths, commit_message)
      begin
        set_commit_message(commit_message)
        vc_client.commit(working_copy_paths)
      rescue Svn::Error => svn_exception
        raise Brazil::VersionControlException, "Failed to commit working copy path: #{working_copy_paths} (#{svn_exception})", caller
      end
    end

    def delete(working_copy_paths)
      begin
        vc_client.delete(working_copy_paths, true)
      rescue Svn::Error => svn_exception
        raise Brazil::VersionControlException, "Could not delete working copy path: #{working_copy_paths} (#{svn_exception})", caller
      end
    end

    def valid_credentials?
      begin
        vc_client.ls(@repository_uri, nil)
      rescue Svn::Error::RA_NOT_AUTHORIZED
        return false
      rescue Svn::Error => svn_exception
        raise Brazil::VersionControlException, "Could not check credentials on url: #{@repository_uri} (#{svn_exception})", caller
      end

      return true
    end

    protected

    def vc_client
      unless @vc_client
        ctx = Svn::Client::Context.new
        ctx.add_simple_prompt_provider(0) do |cred, realm, username, may_save|
          cred.username = @username
          cred.password = @password
          cred.may_save = false
        end
        @vc_client = ctx
      end

      return @vc_client
    end

    def set_commit_message(commit_message)
      begin
        vc_client.set_log_msg_func do |items|
          [true, commit_message]
        end
      rescue Svn::Error => svn_exception
        raise Brazil::VersionControlException, "Could not set commit message: #{commit_message} in repository: #{@repository_uri} (#{svn_exception})", caller
      end
    end

    def repos_list(repos_path, recurse, &block) # :yields: VersionControl::Path
      begin
        vc_client.list(repos_path, nil, nil, recurse, nil, true) do |path, dirent, lock, abs_path|
          vc_path = make_vc_path(repos_path, path, dirent)
          yield vc_path unless vc_path.path == ''
        end
      rescue Svn::Error => svn_exception
        raise Brazil::VersionControlException, "Could not list: #{repos_path} (#{svn_exception})", caller
      end
    end

    def repos_cat(repos_path)
      begin
        return vc_client.cat(repos_path, nil)
      rescue Svn::Error => svn_exception
        raise Brazil::VersionControlException, "Could not cat: #{repos_path}@HEAD (#{svn_exception})", caller
      end
    end

    def repos_copy(vc_revision, commit_message='')
      set_commit_message(commit_message)
      destination_uri = make_revision_path(vc_revision)

      begin
        vc_client.copy(@repository_uri, destination_uri, nil)
      rescue Svn::Error => svn_exception
        raise Brazil::VersionControlException, "Could not tag/branch: #{vc_revision.id} in module: #{destination_uri} (#{svn_exception})", caller
      end
    end

    def make_vc_path(repository_path, path, dirent)
      vc_path = Path.new
      vc_path.path = path

      vc_path.uri = repository_path
      vc_path.uri += '/' + path unless path == ''

      vc_path.file = dirent.file?
      vc_path.directory = dirent.directory?
      vc_path.revision = dirent.created_rev
      vc_path.size = dirent.size
      vc_path.author = dirent.last_author
      return vc_path
    end

  end
end