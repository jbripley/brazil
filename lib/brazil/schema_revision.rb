module Brazil
  class SchemaRevision
    include Comparable
  
    def initialize(major, minor, patch)
      @major = major.to_i if major
      @minor = minor.to_i if minor
      @patch = patch.to_i if patch
    end
    
    def self.from_string(version)
      major, minor, patch = version.split('_')
      SchemaRevision.new(major, minor, patch)
    end
  
    def next
      numbers = to_a
      numbers[-1] += 1
      SchemaRevision.new(numbers[0], numbers[1], numbers[2])
    end
  
    def prev
      numbers = to_a
      numbers[-1] -= 1 if numbers[-1] > 0
      SchemaRevision.new(numbers[0], numbers[1], numbers[2])
    end
    
    def to_s
      if(@major && @minor && @patch)
        "#{@major}_#{@minor}_#{@patch}" 
      elsif(@major && @minor)
        "#{@major}_#{@minor}" 
      elsif @major
        "#{@major}"
      end
    end

    def <=>(other_version)
      if other_version.respond_to?(:to_a)
        return to_a <=> other_version.to_a
      else
        super
      end
    end

    def include?(other_version)
      if other_version.respond_to?(:to_a)
        (other_version.to_a.slice(0, to_a.length) <=> to_a) == 0
      else
        super
      end
    end

    def to_a
      if(@major && @minor && @patch)
        [@major, @minor, @patch] 
      elsif(@major && @minor)
        [@major, @minor]
      elsif @major
        [@major]
      end
    end
    
    def major
      @major.to_i
    end
    
    def minor
      @minor.to_i
    end
    
    def patch
      @patch.to_i
    end
    
  end
end
