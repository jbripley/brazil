module Brazil::VersionControl
  class Path
    attr_accessor :path, :uri, :revision, :size, :author
    attr_writer :file, :directory

    def initialize
      @path = ''
      @uri = ''
      @file = false
      @directory = false
      @revision = -1
      @size = -1
      @author = ''
    end

    def file?
      return @file
    end

    def directory?
      return @directory
    end

    def to_s
      return @uri
    end

  end
end