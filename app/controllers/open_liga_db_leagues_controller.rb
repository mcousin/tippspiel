class OpenLigaDbLeaguesController < ApplicationController

  before_filter :authenticate_admin!

  #################################
  #         ADMINS ONLY           #
  #################################

  # GET /open_liga_db_leagues
  def index
    @open_liga_db_leagues = OpenLigaDbLeague.all
  end

  # GET /open_liga_db_leagues/1
  def show
    @open_liga_db_league = OpenLigaDbLeague.find(params[:id])
  end

  # GET /open_liga_db_leagues/new
  def new
    @open_liga_db_league = OpenLigaDbLeague.new
  end

  # GET /open_liga_db_leagues/1/edit
  def edit
    @open_liga_db_league = OpenLigaDbLeague.find(params[:id])
  end

  # POST /open_liga_db_leagues
  def create
    @open_liga_db_league = OpenLigaDbLeague.new(params[:open_liga_db_league])

    if @open_liga_db_league.save
      redirect_to @open_liga_db_league, notice: 'The open_liga_db_league was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /open_liga_db_leagues/1
  def update
    @open_liga_db_league = OpenLigaDbLeague.find(params[:id])

    if @open_liga_db_league.update_attributes(params[:open_liga_db_league])
      redirect_to @open_liga_db_league, notice: 'The open_liga_db_league was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /open_liga_db_leagues/1
  def destroy
    @open_liga_db_league = OpenLigaDbLeague.find(params[:id])
    @open_liga_db_league.destroy

    redirect_to open_liga_db_leagues_url, notice: 'The open_liga_db_league was successfully destroyed.'
  end
end
