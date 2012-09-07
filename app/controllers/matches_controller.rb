class MatchesController < ApplicationController

  before_filter :authenticate_admin!

  #################################
  #         ADMINS ONLY           #
  #################################

  # GET /matches
  def index
    @matches = Match.all
  end

  # GET /matches/1
  def show
    @match = Match.find(params[:id])
  end

  # GET /matches/new
  def new
    @match = Match.new
  end

  # GET /matches/1/edit
  def edit
    @match = Match.find(params[:id])
  end

  # POST /matches
  def create
    @match = Match.new(params[:match])

    if @match.save
      redirect_to @match, notice: 'Match was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /matches/1
  def update
    @match = Match.find(params[:id])

    if @match.update_attributes(params[:match])
      redirect_to @match, notice: 'Match was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /matches/1
  def destroy
    @match = Match.find(params[:id])
    @match.destroy

    redirect_to matches_url
  end
end
