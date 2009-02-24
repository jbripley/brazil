module Brazil::VersionControl
  class Revision
    attr_reader :type, :id

    def initialize(type, id)
      @type = type
      @id = id.strip
    end

    def ==(other_revision)
      (@type == other_revision.type && @id == other_revision.id)
    end

    def to_s
      "id: #{@id.to_s} type: #{@type.to_s}"
    end

  end
end