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
        expect(luna.abilities[:strength]).to eq 10
        expect(luna.abilities[:dexterity]).to eq 10
        expect(luna.abilities[:constitution]).to eq 10
        expect(luna.abilities[:wisdom]).to eq 10
        expect(luna.abilities[:intelligence]).to eq 10
        expect(luna.abilities[:charisma]).to eq 10
    end
end

RSpec.describe Combat do
    before :each do
        @attacker = Character.new 'Attacker'
        @defender = Character.new 'Defender'
    end

    it "hits when roll is greater than armor" do
        @defender.armor_class = 10
        roll = 11
        combat = Combat.new @attacker, @defender, roll 
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
end

# https://relishapp.com/rspec/rspec-expectations/v/3-10/docs/built-in-matchers/be-matchers
