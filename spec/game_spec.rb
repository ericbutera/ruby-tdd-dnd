require 'game'

RSpec.describe Character do
    it "character has a name" do
        c = Character.new("eric")
        expect(c.name).to eq 'eric'
    end

    it "default alignment is neutral" do
        c = Character.new("luna")
        expect(c.alignment).to eq :neutral
    end

    it "can set alignment to good" do
        c = Character.new("luna")
        c.alignment = :good
        expect(c.alignment).to eq :good
    end

    it "alignments are good, evil, neutral" do
        c = Character.new("luna")
        expect { 
            c.alignment = "invalid-alignment-that-can-never-be" 
        }.to raise_error(ArgumentError)
    end

    it "has 10 armor class" do
        c = Character.new('luna')
        expect(c.armor_class).to eq 10
    end

    it "has 5 hit points" do
        c = Character.new('luna')
        expect(c.hit_points).to eq 5
    end
end

RSpec.describe Combat do
    it "meet or beat opponents armor is a hit" do
        combat = Combat.new
        hit = combat.hit?(armor_class=10, roll=11)
        expect(hit).to be true
    end

    # todo fence post issues

    it "roll less than armor class misses" do
        combat = Combat.new
        hit = combat.hit?(armor_class=10, roll=9)
        expect(hit).to be false
    end

    it "roll of 20 always hits" do
        combat = Combat.new
        hit = combat.hit?(30, 20)
        expect(hit).to be true
    end
end


# https://relishapp.com/rspec/rspec-expectations/v/3-10/docs/built-in-matchers/be-matchers

# roll a 20 sided die
# roll must meet or beat opponents armor class to hit
# a natural roll of 20 always hits

#class Die
#    def roll
#        rand(1..20)
#    end
#end