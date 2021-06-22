class MatchesController < ApplicationController
  before_action :set_match, only: %i[ show edit update destroy ]

  # GET /matches or /matches.json
  def index
    # @matches = Match.all
    @matches = Match.where(completed: false)
  end

  # GET /matches/1 or /matches/1.json
  def show
  end

  # GET /matches/new
  def new
    @match = Match.new
    @members = Member.all
  end

  # GET /matches/1/edit
  def edit
    @members = Member.all
  end

  # POST /matches or /matches.json
  def create
    @match = Match.new(match_params)
    @members = Member.all

    respond_to do |format|
      if @match.save
        format.html { redirect_to matches_url, notice: "Match was successfully created." }
        format.json { render :show, status: :created, location: @match }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /matches/1 or /matches/1.json
  def update
    @match = Match.find(params[:id])
    @match.completed = true
    @member1 = Member.find(@match.member1)
    @member2 = Member.find(@match.member2)

    # update games after every match regardless of outcome
    update_games(@member1, @member2)

    # update rankings based on match outcome
    update_ranks(@member1, @member2, match_params["result"])

    # reset all standings
    # sql = "update Members set games=0;"
    # records_array = ActiveRecord::Base.connection.execute(sql)
    # sql = "update Members set rank= 1 where id = 1;"
    # records_array = ActiveRecord::Base.connection.execute(sql)
    # sql = "update Members set rank= 2 where id = 2;"
    # records_array = ActiveRecord::Base.connection.execute(sql)
    # sql = "update Members set rank= 3 where id = 3;"
    # records_array = ActiveRecord::Base.connection.execute(sql)
    # sql = "update Members set rank= 4 where id = 4;"
    # records_array = ActiveRecord::Base.connection.execute(sql)
    # sql = "update Members set rank= 6 where id = 7;"
    # records_array = ActiveRecord::Base.connection.execute(sql)
    # sql = "update Members set rank= 5 where id = 5;"
    # records_array = ActiveRecord::Base.connection.execute(sql)

    respond_to do |format|
      if @match.update(match_params)
        format.html { redirect_to matches_url, notice: "Match was successfully updated." }
        format.json { render :show, status: :ok, location: @match }

        # remove macth after completion
        # @match.destroy
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matches/1 or /matches/1.json
  def destroy
    @match.destroy
    respond_to do |format|
      format.html { redirect_to matches_url, notice: "Match was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_match
      @match = Match.find(params[:id])
    end

    def update_games (player1, player2)
      sql = "update Members set games = #{Integer(player1.games) + 1} where id = #{player1.id};"
      ActiveRecord::Base.connection.execute(sql)
      sql = "update Members set games = #{Integer(player2.games) + 1} where id = #{player2.id};"
      ActiveRecord::Base.connection.execute(sql)
    end

    def update_ranks(player1, player2, result)

      players = [player1, player2]
      rank_dif = (player1.rank-player2.rank).abs
      underdog = Member.find_by(rank: [player1.rank, player2.rank].max)
      leader = Member.find_by(rank: [player1.rank, player2.rank].min)

      # only update draw matches (result = 0) if players not adjacent in rank
      if result == 0 and dif > 1
        # swop underdog with player adjacent
        sql = "update Members set rank= #{Integer(underdog.rank) + 1} where rank = #{Integer(underdog.rank) - 1 };"
        ActiveRecord::Base.connection.execute(sql)
        sql = "update Members set rank= #{Integer(underdog.rank) - 1} where id = #{underdog.id};"
        ActiveRecord::Base.connection.execute(sql)

      # only other changes happen when underdog wins
      elsif underdog == players[Integer(result)-1]

        # if players not adjacent ranks
        if rank_dif > 1
          # move runner-up to replace and move leader down 1 rank
          sql = "update Members set rank= #{Integer(leader.rank)} where rank = #{Integer(leader.rank) + 1};"
          ActiveRecord::Base.connection.execute(sql)
          sql = "update Members set rank= #{Integer(leader.rank) + 1} where id = #{leader.id};"
          ActiveRecord::Base.connection.execute(sql)

          # move underdog up and other players down in rank
          ranks_to_move = rank_dif/2
          puts ranks_to_move
          sql = "update Members set rank= rank+1 where rank between #{Integer(underdog.rank) - ranks_to_move } and #{Integer(underdog.rank) - 1 };"
          ActiveRecord::Base.connection.execute(sql)
          sql = "update Members set rank= #{Integer(underdog.rank) - ranks_to_move} where id = #{underdog.id};"
          ActiveRecord::Base.connection.execute(sql)

        else

          # if underdog wins against adjacent leader, swap ranks and update game count
          sql = "update Members set rank= #{Integer(leader.rank) + 1} where id = #{leader.id};"
          ActiveRecord::Base.connection.execute(sql)
          sql = "update Members set rank= #{Integer(underdog.rank) - 1 } where id = #{underdog.id};"
          ActiveRecord::Base.connection.execute(sql)

        end
      end
    end

    # Only allow a list of trusted parameters through.
    def match_params
      params.require(:match).permit(:name, :result, :member1, :member2)
    end
end
