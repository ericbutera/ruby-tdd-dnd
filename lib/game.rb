class Character
    attr_reader :name
    def initialize(name, alignment=:neutral)
        @name = name
        @alignment = alignment
    end

    def alignment
        @alignment 
    end

    def alignment=(alignment)
        raise ArgumentError, "Invalid alignment <#{alignment}>" unless ALIGNMENTS.include? alignment
        @alignment = alignment 
    end
end

ALIGNMENTS = [:good, :neutral, :evil]
