class LeaguesController < ApplicationController

  before_filter :authenticate_admin!

  #################################
  #         ADMINS ONLY           #
  #################################

  # GET /leagues
  def index
    @leagues = League.all
  end

  # GET /leagues/1
  def show
    @league = League.find(params[:id])
  end

  # GET /leagues/new
  def new
    @league = League.new
  end

  # GET /leagues/1/edit
  def edit
    @league = League.find(params[:id])
  end

  # POST /leagues
  def create
    @league = League.new(params[:league])

    if @league.save
      redirect_to @league, notice: 'The league was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /leagues/1
  def update
    @league = League.find(params[:id])

    if @league.update_attributes(params[:league])
      redirect_to @league, notice: 'The league was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /leagues/1
  def destroy
    @league = League.find(params[:id])
    @league.destroy

    redirect_to leagues_url, notice: 'The league was successfully destroyed.'
  end
end
