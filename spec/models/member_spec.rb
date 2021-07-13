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

    it 'should update games successfully after match' do
      subject1 = Member.new(name: "player1",
        surname: "player1_surname",
        email: "player1@email",
        birthday: "1988-08-07",
        games: 0,
        rank: 0)

      subject2 = Member.new(name: "player2",
        surname: "player2_surname",
        email: "player2@email",
        birthday: "1988-08-07",
        games: 0,
        rank: 0)

      games1 = subject1.games
      games2 = subject2.games

      update = Member.update_games(subject1, subject2)

      expect(subject1.games).to eq(games1+1)
      expect(subject2.games).to eq(games2+1)
    end

    it 'should swop ranks of adjacent players if lower player wins' do
      subject1 = Member.new(name: "player1",
        surname: "player1_surname",
        email: "player1@email",
        birthday: "1988-08-07",
        games: 0,
        rank: 1)
      player1_init_rank = subject1.rank

      subject2 = Member.new(name: "player2",
        surname: "player2_surname",
        email: "player2@email",
        birthday: "1988-08-07",
        games: 0,
        rank: 2)
      player2_init_rank = subject2.rank

      update = Member.update_ranks(subject1, subject2, '2')

      expect(subject1.rank).to eq(player2_init_rank)
      expect(subject2.rank).to eq(player1_init_rank)
    end

    it 'should only upgrade rank of lower player by 1 if diff in ranks > 1 on draw' do
      subject1 = Member.new(name: "player1",
        surname: "player1_surname",
        email: "player1@email",
        birthday: "1988-08-07",
        games: 0,
        rank: 1)
      player1_init_rank = subject1.rank

      subject2 = Member.new(name: "player2",
        surname: "player2_surname",
        email: "player2@email",
        birthday: "1988-08-07",
        games: 0,
        rank: 3)
      player2_init_rank = subject2.rank

      update = Member.update_ranks_test(subject1, subject2, 0)

      expect(subject1.rank).to eq(player1_init_rank)
      expect(subject2.rank).to eq(player2_init_rank-1)
    end

    it 'should upgrade rank of lower player by rank diff /2 and leading player less 1 on lower player win' do
      subject1 = Member.new(name: "player1",
        surname: "player1_surname",
        email: "player1@email",
        birthday: "1988-08-07",
        games: 0,
        rank: 1)
      player1_init_rank = subject1.rank

      subject2 = Member.new(name: "player2",
        surname: "player2_surname",
        email: "player2@email",
        birthday: "1988-08-07",
        games: 0,
        rank: 6)
      player2_init_rank = subject2.rank

      rank_dif = ((player2_init_rank - player1_init_rank)/2).abs

      update = Member.update_ranks_test(subject1, subject2, 2)

      expect(subject1.rank).to eq(player1_init_rank+1)
      expect(subject2.rank).to eq(player2_init_rank-rank_dif)
    end

  end

end
