class MatchesController < ApplicationController
  before_action :set_match, only: %i[ show edit update destroy ]

  # GET /matches or /matches.json
  def index
    @matches = Match.all
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

    respond_to do |format|
      if @match.save
        format.html { redirect_to @match, notice: "Match was successfully created." }
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
    @member1 = Member.find(@match.member1)
    @member2 = Member.find(@match.member2)

    # update games after every match regardless of outcome
    sql = "update Members set games = #{Integer(@member1.games) + 1} where id = #{@member1.id};"
    records_array = ActiveRecord::Base.connection.execute(sql)
    sql = "update Members set games = #{Integer(@member2.games) + 1} where id = #{@member2.id};"
    records_array = ActiveRecord::Base.connection.execute(sql)


# to be refractored
    # first check if match was save with a result
    if @match.result
      # result "1" mens member1 is the winner of the match
      if match_params["result"] == "1"
        @leader = Member.find_by(rank: [@member1.rank, @member2.rank].min)
        rank_dif = ((@member1.rank - @member2.rank).abs)
        # if member1 wins and is not the leader and players not adjacent
        if rank_dif > 1 and (@member1 != @leader)

          # move runner-up to replace and move leader down 1 rank
          sql = "update Members set rank= #{Integer(@member2.rank)} where rank = #{Integer(@member2.rank) + 1};"
          records_array = ActiveRecord::Base.connection.execute(sql)
          sql = "update Members set rank= #{Integer(@member2.rank) + 1} where id = #{@member2.id};"
          records_array = ActiveRecord::Base.connection.execute(sql)

          # move underdog up and other players down in rank
          ranks_to_move = rank_dif/2
          puts ranks_to_move
          sql = "update Members set rank= rank+1 where rank between #{Integer(@member1.rank) - ranks_to_move } and #{Integer(@member1.rank) - 1 };"
          records_array = ActiveRecord::Base.connection.execute(sql)
          sql = "update Members set rank= #{Integer(@member1.rank) - ranks_to_move} where id = #{@member1.id};"
          records_array = ActiveRecord::Base.connection.execute(sql)

        elsif rank_dif = 1 and (@member1 != @leader)
          # if underdog wins against adjacent leader, swap ranks and update game count
          sql = "update Members set rank= #{Integer(@member2.rank) + 1} where id = #{@member2.id};"
          records_array = ActiveRecord::Base.connection.execute(sql)
          sql = "update Members set rank= #{Integer(@member1.rank) - 1 } where id = #{@member1.id};"
          records_array = ActiveRecord::Base.connection.execute(sql)

        end
      end

      # result "2" mens member2 is the winner of the match
      if match_params["result"] == "2"
        @leader = Member.find_by(rank: [@member1.rank, @member2.rank].min)
        rank_dif = ((@member1.rank - @member2.rank).abs)

        if rank_dif > 1 and (@member2 != @leader)
          sql = "update Members set rank= #{Integer(@member1.rank)} where rank = #{Integer(@member1.rank) + 1};"
          records_array = ActiveRecord::Base.connection.execute(sql)
          sql = "update Members set rank= #{Integer(@member1.rank) + 1} where id = #{@member1.id};"
          records_array = ActiveRecord::Base.connection.execute(sql)

          # move underdog up and other players down in rank
          ranks_to_move = rank_dif/2
          puts ranks_to_move
          sql = "update Members set rank= rank+1 where rank between #{Integer(@member2.rank) - ranks_to_move } and #{Integer(@member2.rank) - 1 };"
          records_array = ActiveRecord::Base.connection.execute(sql)
          sql = "update Members set rank= #{Integer(@member2.rank) - ranks_to_move} where id = #{@member2.id};"
          records_array = ActiveRecord::Base.connection.execute(sql)

        elsif rank_dif = 1 and (@member2 != @leader)
          # if underdog wins against adjacent leader, swap ranks and update game count
          sql = "update Members set rank= #{Integer(@member1.rank) + 1} where id = #{@member1.id};"
          records_array = ActiveRecord::Base.connection.execute(sql)
          sql = "update Members set rank= #{Integer(@member2.rank) - 1 } where id = #{@member2.id};"
          records_array = ActiveRecord::Base.connection.execute(sql)

        end
      end

      # result "0" mens draw
      if match_params["result"] == "0"
        rank_dif = ((@member1.rank - @member2.rank).abs)
        # only change happend when ranks not adjacent
        # move underdog one rank up
        if rank_dif > 1
          @underdog = Member.find_by(rank: [@member1.rank, @member2.rank].max)
          sql = "update Members set rank= #{Integer(@underdog.rank) + 1} where rank = #{Integer(@underdog.rank) - 1 };"
          records_array = ActiveRecord::Base.connection.execute(sql)
          sql = "update Members set rank= #{Integer(@underdog.rank) - 1} where id = #{@underdog.id};"
          records_array = ActiveRecord::Base.connection.execute(sql)
        end
      end


    end

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
        format.html { redirect_to @match, notice: "Match was successfully updated." }
        format.json { render :show, status: :ok, location: @match }

        # remove macth after completion
        @match.destroy
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

    # Only allow a list of trusted parameters through.
    def match_params
      params.require(:match).permit(:name, :result, :member1, :member2)
    end
end
