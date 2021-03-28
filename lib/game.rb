##
# The hero in a story
class Character
    attr_reader :name, :armor_class, :hit_points

    DEFAULT_ARMOR_CLASS = 10
    DEFAULT_HIT_POINTS = 5

    ##
    # Create a new hero
    # Params:
    # +name+ Hero name
    # +alignment+ An alignment- defaults to :neutral
    def initialize(name, alignment=:neutral)
        @name = name
        @alignment = alignment
        @armor_class = DEFAULT_ARMOR_CLASS
        @hit_points = DEFAULT_HIT_POINTS
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


##
# Define rules of combat
class Combat
    ##
    # Magic roll 20 always hits
    ROLL_ALWAYS_HITS = 20

    ##
    # When an attack happens, is it a hit?
    # +armor_class+ Character's armor class
    # +roll+ the die roll
    def hit?(armor_class, roll)
        is_always_hit = roll == ROLL_ALWAYS_HITS
        is_roll_above_ac = roll >= armor_class

        is_always_hit || is_roll_above_ac
    end
end