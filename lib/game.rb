##
# The hero in a story
class Character
    attr_reader :name, :armor_class, :hit_points
    attr_writer :armor_class

    ALIGNMENTS = [:good, :neutral, :evil]
    DEFAULT_ALIGNMENT = :neutral
    DEFAULT_ARMOR_CLASS = 10
    DEFAULT_HIT_POINTS = 5
    DEFAULT_ABILITY = 10
    ABILITY_MIN = 1
    ABILITY_MAX = 20

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

        # todo abilities range from 1 to 20
        @abilities = {
            :strength => DEFAULT_ABILITY,
            :dexterity => DEFAULT_ABILITY,
            :constitution => DEFAULT_ABILITY,
            :wisdom => DEFAULT_ABILITY,
            :intelligence => DEFAULT_ABILITY,
            :charisma => DEFAULT_ABILITY
        }
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

    def is_alive?
        @hit_points > 0
    end

    def ability(ability)
        raise ArgumentError, "Invalid ability <#{ability}>" unless @abilities.has_key? ability
        @abilities[ability]
    end

    def set_ability(ability, value)
        # todo research better way to handle get/set
        raise ArgumentError, "Attribute value must be between 1 and 20. Given <#{value}>" unless value.between?(ABILITY_MIN, ABILITY_MAX)
        @abilities[ability] = value 
    end
end

##
# Define rules of combat
class Combat
    ##
    # Magic roll 20 always hits
    CRITICAL_HIT = 20

    def initialize(attacker, defender, roll) 
        @attacker = attacker
        @defender = defender
        @roll = roll

        # modified strength used to increase roll 
        @strength = strength 
    end

    ##
    # Calculate strength of attack. On critical hits strength will be doubled
    def strength
        strength = Modifier.score(@attacker.ability(:strength))
        is_hit_critical ? strength * 2 : strength
    end

    ##
    # Can the defender be attacked?
    def hit?
        is_hit_critical || is_hit_successful
    end

    ##
    # Perform attack, return damage
    def hit
        return 1 + @strength if @strength > 0
        return 2 if is_hit_critical
        return 1 if is_hit_successful
        0
    end

    def is_hit_critical
        @roll == CRITICAL_HIT
    end

    def is_hit_successful
        roll = @roll + @strength
        roll >= @defender.armor_class 
    end
end

class Modifier
    def Modifier.score(score)
        m = score - 10
        m / 2
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