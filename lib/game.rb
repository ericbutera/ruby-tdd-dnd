##
# The hero in a story
class Character
    attr_reader :name, :armor_class, :hit_points, :experience, :level
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
        @level = 1
        @experience = 0

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
        constitution = modifier :constitution 
        attempt = @hit_points - hit_points

        if constitution > 0 && attempt < 1
            # resurrection! mwa ha ha
            @hit_points = constitution
        else 
            @hit_points = attempt
        end
    end

    def alignment
        @alignment 
    end

    def alignment=(alignment)
        raise ArgumentError, "Invalid alignment <#{alignment}>" unless ALIGNMENTS.include? alignment
        @alignment = alignment 
    end

    def experience=(xp)
        attempt = @experience + xp

        # level up! take any xp over level threshold and apply towards next level..
        next_level_xp = level * 1000
        if attempt >= next_level_xp
            @level += 1
            attempt = attempt - next_level_xp
        end

        @experience = attempt
    end

    ##
    # Set character level
    def level=(level)
        # hit points increase by 5 plus constitution modifier
        constitution = modifier :constitution 
        multiplier = DEFAULT_HIT_POINTS + constitution
        @hit_points = multiplier * level

        @level = level
    end

    def hit_points
        hp = @hit_points
    end

    ##
    # Override character hit points to any amount
    def hit_points=(points)
        @hit_points = points
    end

    def alive?
        @hit_points > 0
    end

    def ability(ability)
        raise ArgumentError, "Invalid ability <#{ability}>" unless @abilities.has_key? ability
        @abilities[ability]
    end

    def set_ability(ability, score)
        # todo research better way to handle get/set
        raise ArgumentError, "Attribute score must be between 1 and 20. Given <#{score}>" unless score.between?(ABILITY_MIN, ABILITY_MAX)
        @abilities[ability] = score 
    end

    def level_attack_damage
        # 1 is added to attack roll for every even level achieved
        level / 2
    end

    ##
    # character specific defense enhancements
    def defend_modifier
        dexterity = modifier :dexterity 
        armor_class + dexterity
    end

    ##
    # character specific attack enhancements
    def attack_modifier
        # strength modifies attack roll
        strength = modifier :strength 
        strength + level_attack_damage
    end

    def modifier(ability)
        Modifier.score ability(ability)
    end
end

class Fighter < Character
    # attacks roll is increased by 1 for every level instead of every other level
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
    end

    ##
    # Can the defender be attacked?
    def hit?
        is_hit_critical || is_hit_successful
    end

    ##
    # Perform attack, return damage
    def hit
        # refactor- i don't like how hit? and hit are mostly the same
        # methods shouldnt be called multiple times
        # attacker xp is intermingled with hit which might be better in 'Game'

        if hit? # TODO fix, this calls so many methods
            @attacker.experience += 10
        end

        damage
    end

    private
    ##
    # Die roll with modifiers
    def roll
        @roll + @attacker.attack_modifier
    end

    def is_hit_critical
        @roll == CRITICAL_HIT
    end

    def is_hit_successful
        roll >= @defender.defend_modifier
    end

    ##
    # Attacker Strength modifier increases damage in two ways:
    # - critical hits double modifier
    # - base damage is increased by modifier
    def attacker_strength_damage
        # add strength modifier to damage dealt
        strength = @attacker.modifier :strength 
        strength = strength * 2 if is_hit_critical
        strength
    end

    def critical_hit_doubles_damage(damage)
        damage *= 2 if is_hit_critical
        damage
    end

    def damage
        amount = 0 # base damage
        amount += 1 if is_hit_successful
        amount += attacker_strength_damage
        amount = critical_hit_doubles_damage amount
    end
end

class Modifier
    ##
    # Convert a character ability score into a modified score.
    #
    # Score  Mod
    # -----  ---
    #     1   -5
    #    10    0
    #    20   +5
    #
    # +score+ Ability score Range 1 to 20
    # returns modifier -5 to +5
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