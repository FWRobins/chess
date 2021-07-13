require 'rails_helper'

RSpec.describe Match, type: :model do
  context 'validation test' do
    it 'ensures name presence' do
      member = Match.new(member1: "member1", member2: "member2",).save
      expect(member).to eq(false)
    end

    it 'ensures member1 presence' do
      member = Match.new(name: "name", member2: "member2", ).save
      expect(member).to eq(false)
    end

    it 'ensures member2 presence' do
      member = Match.new(name: "name", member1: "member1", ).save
      expect(member).to eq(false)
    end

    it 'should save successfully' do
      member = Match.new(name: "name", member1: 1, member2: 2, completed: false).save
      expect(member).to eq(true)
    end
  end

end
