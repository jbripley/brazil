require 'brazil/version_control'
require 'brazil/version_control/path'

module Brazil::VersionControl
  class SVNGeneric < VersionControl

    def cat(relative_repos_path, vc_revision=nil)
      repos_path = make_revision_path(vc_revision, relative_repos_path)
      return repos_cat(repos_path)
    end

    def list(relative_repos_path, vc_revision=nil, recurse=false, &block) # :yields: VersionControl::Path
      repos_path = make_revision_path(vc_revision, relative_repos_path)
      return repos_list(repos_path, recurse, &block)
    end

    def tag(vc_revision, commit_message='')
      repos_copy(vc_revision, commit_message)
    end

    def list_tags() # :yields: VersionControl::Revision
      tag_dir = "#{module_root_uri}tags"

      repos_list(tag_dir, false) do |vc_path|
        yield Revision.new(REVISION_TYPE_TAG, vc_path.path) if vc_path.directory?
      end
    end

    def branch(vc_revision, commit_message='')
      repos_copy(vc_revision, commit_message)
    end

    def list_branches() # :yields: VersionControl::Revision
      branch_dir = "#{module_root_uri}branches"

      repos_list(branch_dir, false) do |vc_path|
        yield Revision.new(REVISION_TYPE_BRANCH, vc_path.path) if vc_path.directory?
      end
    end

    protected

    def module_root_uri
      match = /(.*\/)(tags|trunk|branches)/.match(@repository_uri)
      if match
        return match[1]
      else
        return @repository_uri + '/'
        # raise Brazil::VersionControlException, 'Could not find the modules root dir in repository: ' + @repository_uri, caller
      end
    end

    def make_revision_path(vc_revision=nil, relative_repos_path = '')
      if vc_revision.nil?
        repos_path = @repository_uri
      else
        case vc_revision.type
        when REVISION_TYPE_TAG
          repos_path = "#{module_root_uri}tags/#{vc_revision.id}"
        when REVISION_TYPE_BRANCH
          repos_path = "#{module_root_uri}branches/#{vc_revision.id}"
        when REVISION_TYPE_TRUNK
          repos_path = module_root_uri + 'trunk'
        else
          raise Brazil::VersionControlException, "Unknown revision type: #{vc_revision.type}", caller
        end
      end

      repos_path += '/' + relative_repos_path unless relative_repos_path == ''
      return repos_path
    end

  end
end