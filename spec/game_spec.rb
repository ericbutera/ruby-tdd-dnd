require 'game'

RSpec.describe Character, "#name" do
    it "character has a name" do
        c = Character.new("eric")
        expect(c.name).to eq 'eric'
    end
end