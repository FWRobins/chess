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
    Member.update_games(@member1, @member2)

    # update rankings based on match outcome
    Member.update_ranks(@member1, @member2, match_params["result"])


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


    # Only allow a list of trusted parameters through.
    def match_params
      params.require(:match).permit(:name, :result, :member1, :member2)
    end
end
