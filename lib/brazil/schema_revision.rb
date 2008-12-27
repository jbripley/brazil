module Brazil
  class SchemaRevision
    # _VERSION_ADMIN_3_3_12 => ['_VERSION_ADMIN', '3_3_12']
    SCHEMA_VERSION = /(^.*?)_([_\d]+)$/
  
    include Comparable
    attr_reader :schema, :version
  
    def initialize(schema, version)
      if schema.nil?
        @schema = nil
      else
        @schema = schema.strip
      end

      if version.nil?
        @version = nil
      else
        @version = version.strip
      end    
    end
    
    def self.from_string(string)
      # validate format and extract schema and version
      matches = SCHEMA_VERSION.match(string.strip)
      if matches
        schema = matches[1]
        version = matches[2]
        return SchemaRevision.new(schema, version)
      else
        return nil
      end
    end
  
    def next
      numbers = to_a
      numbers[-1] += 1
      SchemaRevision.new(@schema, numbers.join('_'))
    end
  
    def prev
      numbers = to_a
      numbers[-1] -= 1
      SchemaRevision.new(@schema, numbers.join('_'))
    end

    def to_s
      "_VERSION_#{@schema.upcase}_#{@version}"
    end
  
    def <=>(other_version)
      if @version.respond_to?(:to_a)
        return to_a <=> other_version.to_a
      else
        # @version == nil => trunk or branch, whichs is always the latest version
        return 1
      end
    end
  
    def include?(other_version)
      return (other_version.to_a.slice(0, to_a.length) <=> to_a) == 0
    end
  
    def to_a
      if @version.respond_to?(:split)
        @version.split('_').collect { |version_number_string| version_number_string.to_i }
      else
        Array.new
      end
    end
  end
end
