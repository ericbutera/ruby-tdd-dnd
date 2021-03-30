require 'game'

RSpec.describe Character do
    before :each do
        @hero = Character.new 'Luna'
    end

    it "has a name" do
        expect(@hero.name).to eq 'Luna'
    end

    it "can use different names" do
        cinnamon = Character.new 'Cinnamon'
        expect(cinnamon.name).to eq 'Cinnamon'
    end

    it "has default alignment is neutral" do
        expect(@hero.alignment).to eq :neutral
    end

    it "can set alignment to good" do
        @hero.alignment = :good
        expect(@hero.alignment).to eq :good
    end

    it "has alignments: good, evil, neutral" do
        expect { 
            @hero.alignment = "invalid-alignment-that-can-never-be" 
        }.to raise_error(ArgumentError)
    end

    it "has 10 armor class" do
        expect(@hero.armor_class).to eq 10
    end

    it "has 5 hit points" do
        expect(@hero.hit_points).to eq 5
    end    

    it "takes 1 damage reducing hit points to 4" do
        @hero.damaged 1
        expect(@hero.hit_points).to eq 4
    end

    it "hit points increase by 5 per level" do
        hit_points = @hero.hit_points
        @hero.level = 3
        expect(@hero.hit_points).to eq 15
    end

    it "hit points increase by 5 + constitution per level" do
        hit_points = @hero.hit_points
        @hero.set_ability(:constitution, 12)
        @hero.level = 2
        expect(@hero.hit_points).to eq 12 # 10hp + 1const
    end

    it "is alive" do
        expect(@hero.is_alive?).to be true
    end

    it "has expired" do
        @hero.damaged(@hero.hit_points)
        expect(@hero.is_alive?).to be false
    end

    it "has abilities that default to 10" do
        expect(@hero.ability :strength).to eq 10
        expect(@hero.ability :dexterity).to eq 10
        expect(@hero.ability :constitution).to eq 10
        expect(@hero.ability :wisdom).to eq 10
        expect(@hero.ability :intelligence).to eq 10
        expect(@hero.ability :charisma).to eq 10
    end

    it "has abilities that must be above 1" do
        expect { 
            @hero.set_ability :strength, 0
        }.to raise_error(ArgumentError)
    end

    it "has abilities that must be below 21" do
        expect { 
            @hero.set_ability :strength, 21
        }.to raise_error(ArgumentError)
    end

    it "has 0 experience at creation" do
        expect(@hero.experience).to eq 0
    end

    it "is level 1 at creation" do
        expect(@hero.level).to eq 1
    end

    it "is level 2 at 2000 xp" do
        @hero.experience = 1000
        expect(@hero.level).to eq 2
    end

    it "extra xp counts towards next level" do
        @hero.experience = 1010
        expect(@hero.level).to eq 2
        expect(@hero.experience).to eq 10
    end

    it "is level 3 at 3000 xp" do
        @hero.experience = 1000
        @hero.experience = 1000
        @hero.experience = 1000
        expect(@hero.level).to be 3
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

    it "1 is added to attack roll for every even level achieved" do
        combat = Combat.new @attacker, @defender, roll=9
        @attacker.level=2
        damage = combat.hit
        expect(damage).to eq 1
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

    it "strength modifier of 14 makes attack roll above armor of defender" do
        roll = 9
        @attacker.set_ability :strength, 14 
        combat = Combat.new @attacker, @defender, roll
        expect(combat.hit?).to be true
    end

    it "weak roll causes no damage" do
        combat = Combat.new @attacker, @defender, roll=1
        expect(combat.hit).to eq 0
    end

    it "attack equal to defense causes 1 damage" do
        combat = Combat.new @attacker, @defender, roll=10
        expect(combat.hit).to eq 1
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
        expect(damage).to eq 12 # 1 base dmg + (5 str doubled)
    end

    it "strength causes minimum damage to always be 1 even if roll less than defender amor" do
        @attacker.set_ability :strength, 12
        @defender.armor_class = 10
        combat = Combat.new @attacker, @defender, roll=1
        damage = combat.hit
        expect(damage).to eq 1 
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
