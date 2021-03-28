require 'game'

RSpec.describe Character, "#name" do
    context "character has a name" do
        it "thing" do
            c = Character.new("eric")
            expect(c.name).to eq 'eric'
        end
    end
end