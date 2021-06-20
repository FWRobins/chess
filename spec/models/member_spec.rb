require 'rails_helper'

RSpec.describe Member, type: :model do
  context 'validation test' do
    it 'ensures name presence' do
      member = Member.new(surname: "surname", email: "email", birthday: "birthday", ).save
      expect(member).to eq(false)
    end
    it 'ensures surname presence' do
      member = Member.new(name: "name", email: "email", birthday: "birthday", ).save
      expect(member).to eq(false)
    end
    it 'ensures email presence' do
      member = Member.new(surname: "surname", name: "name", birthday: "birthday", ).save
      expect(member).to eq(false)
    end
    it 'ensures birthday presence' do
      member = Member.new(surname: "surname", email: "email", name: "name", ).save
      expect(member).to eq(false)
    end
    it 'should save successfully' do
      member = Member.new(name: "name", surname: "surname", email: "email", birthday: "1988-08-07", games: 0, rank: 0).save
      expect(member).to eq(true)
    end
  end

end
