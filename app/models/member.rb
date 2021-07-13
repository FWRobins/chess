class Member < ApplicationRecord


  validates :name, :surname, :email, :birthday, :games, :rank, presence: true

  def self.update_games(player1, player2)
    player1.games += 1
    player1.save()
    player2.games += 1
    player2.save()
  end

  def self.update_ranks(player1, player2, result)
    result = Integer(result)
    players = [player1, player2]
    rank_dif = (player1.rank-player2.rank).abs
    if player1.rank < player2.rank
      underdog = player2
      leader = player1
    else
      underdog = player1
      leader = player2
    end


    # only update draw matches (result = 0) if players not adjacent in rank
    if result == 0 and rank_dif > 1
      # swop underdog with player adjacent
      non_player = Member.find_by(rank: underdog.rank-1)
      non_player.rank +=1
      non_player.save()

      underdog.rank -=1
      underdog.save()

    # only other changes happen when underdog wins
    elsif underdog == players[Integer(result)-1]

      # if players not adjacent ranks
      if rank_dif > 1
        # move runner-up to replace and move leader down 1 rank

        non_player = Member.find_by(rank: leader.rank+1)
        non_player.rank -=1
        non_player.save()

        leader.rank +=1
        leader.save()

        # move underdog up and other players down in rank
        ranks_to_move = rank_dif/2
        puts ranks_to_move

        non_players = Member.where(rank: underdog.rank-ranks_to_move..underdog.rank-1)
        for non_player in non_players
          non_player.rank +=1
          non_player.save()
        end

        underdog.rank -= ranks_to_move
        underdog.save()

      else

        # if underdog wins against adjacent leader, swap ranks and update game count
        leader.rank += 1
        leader.save()

        underdog.rank -= 1
        underdog.save()

      end
    end
  end

  # function for rspec tests
  # ignores other board members not related to match
  def self.update_ranks_test(player1, player2, result)
    result = Integer(result)
    players = [player1, player2]
    rank_dif = (player1.rank-player2.rank).abs
    if player1.rank < player2.rank
      underdog = player2
      leader = player1
    else
      underdog = player1
      leader = player2
    end
    # underdog = Member.find_by(rank: [player1.rank, player2.rank].max)
    # leader = Member.find_by(rank: [player1.rank, player2.rank].min)


    # only update draw matches (result = 0) if players not adjacent in rank
    if result == 0 and rank_dif > 1
      # swop underdog with player adjacent
      # non_player = Member.find_by(rank: underdog.rank-1)
      # non_player.rank +=1
      # non_player.save()

      underdog.rank -=1
      underdog.save()

    # only other changes happen when underdog wins
    elsif underdog == players[Integer(result)-1]

      # if players not adjacent ranks
      if rank_dif > 1
        # move runner-up to replace and move leader down 1 rank

        # non_player = Member.find_by(rank: leader.rank+1)
        # non_player.rank -=1
        # non_player.save()

        leader.rank +=1
        leader.save()

        # move underdog up and other players down in rank
        ranks_to_move = rank_dif/2
        puts ranks_to_move

        # non_players = Member.where(rank: underdog.rank-ranks_to_move..underdog.rank-1)
        # for non_player in non_players
        #   non_player.rank +=1
        #   non_player.save()
        # end

        underdog.rank -= ranks_to_move
        underdog.save()

      else

        # if underdog wins against adjacent leader, swap ranks and update game count
        leader.rank += 1
        leader.save()

        underdog.rank -= 1
        underdog.save()

      end
    end
  end

  # update all ranks om member deletion
  def self.delete_member(member)
    lower_members = Member.where("rank > ?", member.rank)
    for lower_member in lower_members
      lower_member.rank -=1
      lower_member.save()
    end

    Match.member_delete(member)

  end

end
