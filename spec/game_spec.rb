require 'game'

RSpec.describe Character, "#name" do
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

end