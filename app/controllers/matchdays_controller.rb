class MatchdaysController < ApplicationController
  
  before_filter :authenticate_admin!, :except => [:index, :show]
  
  # GET /matchdays
  # GET /matchdays.json
  def index
    @matchdays = Matchday.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @matchdays }
    end
  end

  # GET /matchdays/1
  # GET /matchdays/1.json
  def show
    @matchday = Matchday.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @matchday }
    end
  end
  
  #################################
  #         ADMINS ONLY           #
  #################################

  # GET /matchdays/new
  # GET /matchdays/new.json
  def new
    @matchday = Matchday.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @matchday }
    end
  end

  # GET /matchdays/1/edit
  def edit
    @matchday = Matchday.find(params[:id])
  end

  # POST /matchdays
  # POST /matchdays.json
  def create
    @matchday = Matchday.new(params[:matchday])

    respond_to do |format|
      if @matchday.save
        format.html { redirect_to @matchday, notice: 'Matchday was successfully created.' }
        format.json { render json: @matchday, status: :created, location: @matchday }
      else
        format.html { render action: "new" }
        format.json { render json: @matchday.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /matchdays/1
  # PUT /matchdays/1.json
  def update    
    @matchday = Matchday.find(params[:id])

    respond_to do |format|
      if @matchday.update_attributes(params[:matchday])
        format.html { redirect_to @matchday, notice: 'Matchday was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @matchday.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matchdays/1
  # DELETE /matchdays/1.json
  def destroy
    @matchday = Matchday.find(params[:id])
    @matchday.destroy

    respond_to do |format|
      format.html { redirect_to matchdays_url }
      format.json { head :no_content }
    end
  end
end
