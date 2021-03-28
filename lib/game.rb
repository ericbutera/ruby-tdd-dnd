##
# The hero in a story
class Character
    attr_reader :name, :armor_class, :hit_points

    ALIGNMENTS = [:good, :neutral, :evil]
    DEFAULT_ALIGNMENT = :neutral
    DEFAULT_ARMOR_CLASS = 10
    DEFAULT_HIT_POINTS = 5

    ##
    # Create a new hero
    # Params:
    # +name+ Hero name
    # +alignment+ An alignment- defaults to :neutral
    def initialize(name, alignment=DEFAULT_ALIGNMENT)
        @name = name
        @alignment = alignment
        @armor_class = DEFAULT_ARMOR_CLASS
        @hit_points = DEFAULT_HIT_POINTS
    end

    def damaged(hit_points)
        @hit_points -= hit_points
    end

    def alignment
        @alignment 
    end

    def alignment=(alignment)
        raise ArgumentError, "Invalid alignment <#{alignment}>" unless ALIGNMENTS.include? alignment
        @alignment = alignment 
    end
end

##
# Define rules of combat
class Combat
    ##
    # Magic roll 20 always hits
    CRITICAL_HIT = 20

    def initialize(defender_armor_class, roll)
        @defender_armor_class = defender_armor_class
        @roll = roll
    end

    ##
    # Can the defender be attacked?
    def hit?
        is_hit_critical || is_hit_successful
    end

    ##
    # Perform attack, determine damage
    def hit
        return 2 if is_hit_critical
        return 1 if is_hit_successful
        0
    end

    def is_hit_critical
        @roll == CRITICAL_HIT
    end

    def is_hit_successful
        @roll >= @defender_armor_class
    end
end

class Game
    def initialize(player1, player2)
        @player1 = player1
        @player2 = player2
    end

    def battle
        # game.current_turn => attacker = p1, defender = p2
        # attacker rolls die => die=20
        # damage = combat.hit(defender.armor_class, roll)
        # defender.damage(damage)
        # game.next_turn
    end
end

#class Die
#    def roll
#        rand(1..20)
#    end
#end