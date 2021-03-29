require 'game'

RSpec.describe Character do
    it "has a name" do
        c = Character.new "eric" 
        expect(c.name).to eq 'eric'
    end

    it "has default alignment is neutral" do
        c = Character.new 'luna'
        expect(c.alignment).to eq :neutral
    end

    it "can set alignment to good" do
        c = Character.new 'luna'
        c.alignment = :good
        expect(c.alignment).to eq :good
    end

    it "has alignments: good, evil, neutral" do
        c = Character.new "luna"
        expect { 
            c.alignment = "invalid-alignment-that-can-never-be" 
        }.to raise_error(ArgumentError)
    end

    it "has 10 armor class" do
        c = Character.new 'luna'
        expect(c.armor_class).to eq 10
    end

    it "has 5 hit points" do
        c = Character.new 'luna'
        expect(c.hit_points).to eq 5
    end    

    it "takes 1 damage reducing hit points to 4" do
        luna = Character.new 'luna'
        luna.damaged 1
        expect(luna.hit_points).to eq 4
    end

    it "is alive" do
        luna = Character.new 'luna'
        expect(luna.is_alive?).to be true
    end

    it "has expired" do
        cinnamon = Character.new 'Cinnamon'
        cinnamon.damaged(cinnamon.hit_points)
        expect(cinnamon.is_alive?).to be false
    end

    it "has abilities that default to 10" do
        luna = Character.new 'luna'
        expect(luna.ability :strength).to eq 10
        expect(luna.ability :dexterity).to eq 10
        expect(luna.ability :constitution).to eq 10
        expect(luna.ability :wisdom).to eq 10
        expect(luna.ability :intelligence).to eq 10
        expect(luna.ability :charisma).to eq 10
    end

    it "has abilities that must be above 1" do
        luna = Character.new 'luna'
        expect { 
            luna.set_ability :strength, 0
        }.to raise_error(ArgumentError)
    end

    it "has abilities that must be below 21" do
        luna = Character.new 'luna'
        expect { 
            luna.set_ability :strength, 21
        }.to raise_error(ArgumentError)
    end

    it "has 0 experience at creation" do
        luna = Character.new 'luna'
        expect(luna.experience).to eq 0
    end

    it "is level 1 at creation" do
        luna = Character.new 'luna'
        expect(luna.level).to eq 1
    end
end

RSpec.describe Combat do
    before :each do
        @attacker = Character.new 'Attacker'
        @defender = Character.new 'Defender'
    end

    it "hits when roll is greater than armor" do
        @defender.armor_class = 10
        combat = Combat.new @attacker, @defender, roll=11
        hit = combat.hit?
        expect(hit).to be true
    end

    it "misses when roll is less than armor" do
        @defender.armor_class = 10
        roll = 9
        combat = Combat.new @attacker, @defender, roll 
        hit = combat.hit?
        expect(hit).to be false
    end

    it "always hits on critical roll" do
        @defender.armor_class = 30
        roll = 20
        combat = Combat.new @attacker, @defender, roll 
        hit = combat.hit?
        expect(hit).to be true
    end

    it "hits player for 1 damage" do
        @defender.armor_class = 10
        roll = 11
        combat = Combat.new @attacker, @defender, roll
        damage = combat.hit
        expect(damage).to eq 1
    end

    it "hits player for double damage on critical roll" do
        @defender.armor_class = 20
        roll = 20
        combat = Combat.new @attacker, @defender, roll
        damage = combat.hit
        expect(damage).to eq 2
    end

    it "causes no damage if armor is stronger than roll" do
        @defender.armor_class = 2
        roll = 1
        combat = Combat.new @attacker, @defender, roll
        damage = combat.hit
        expect(damage).to eq 0
    end

    it "causes damage if armor is equal to roll" do
        @defender.armor_class = 10
        roll = 10
        combat = Combat.new @attacker, @defender, roll
        damage = combat.hit
        expect(damage).to eq 1
    end

    it "gives attacker 10xp upon successful hit" do
        combat = Combat.new @attacker, @defender, roll=20
        # im not so sure combat.hit makes sense anymore.. 
        combat.hit
        expect(@attacker.experience).to eq 10
    end
end

RSpec.describe "Modifier Calculation" do
    it 'score 1 is -5' do
        modifier = Modifier.score 1
        expect(modifier).to eq -5
    end

    it 'score 10 is 0' do
        modifier = Modifier.score 10
        expect(modifier).to eq 0
    end

    it 'score 20 is 5' do
        modifier = Modifier.score 20
        expect(modifier).to eq 5
    end
end

RSpec.describe "Modifier" do
    before :each do
        @attacker = Character.new 'Attacker'
        @defender = Character.new 'Defender'
    end

    # add Strength modifier to:
    #   attack roll and damage dealt
    #   double Strength modifier on critical hits
    #   minimum damage is always 1 (even on a critical hit)
    # add Dexterity modifier to armor class
    # add Constitution modifier to hit points (always at least 1 hit point)
    it "strength modifier of 14 makes attack roll above armor of defender" do
        roll = 9
        @attacker.set_ability :strength, 14 
        combat = Combat.new @attacker, @defender, roll
        expect(combat.hit?).to be true
    end

    it "strength 12 increases damage dealt by 1" do
        @attacker.set_ability :strength, 12
        combat = Combat.new @attacker, @defender, roll=10
        damage = combat.hit
        expect(damage).to eq 2
    end

    it "strength modifier doubles on critical hit" do
        @attacker.set_ability :strength, 20
        combat = Combat.new @attacker, @defender, roll=Combat::CRITICAL_HIT
        damage = combat.hit
        expect(damage).to eq 11
    end

    it "strength causes minimum damage to always be 1" do
        @attacker.set_ability :strength, 12
        @defender.armor_class = 10
        combat = Combat.new @attacker, @defender, roll=1
        damage = combat.hit
        expect(damage).to eq 2 # 1 base damage, +1 damage because strength
    end

    it "dexterity 12 increases armor by 1" do
        @defender.set_ability :dexterity, 12
        combat = Combat.new @attacker, @defender, roll=10
        damage = combat.hit
        expect(damage).to eq 0
    end

    it "constitution ensures at least 1 hit point" do
        @defender.set_ability :constitution, 12
        @defender.damaged(10000000)
        expect(@defender.hit_points).to eq 1
    end
end

# https://relishapp.com/rspec/rspec-expectations/v/3-10/docs/built-in-matchers/be-matchers
