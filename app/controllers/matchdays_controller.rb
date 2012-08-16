class MatchdaysController < ApplicationController
  
  before_filter :authenticate_admin!
  
  before_filter :create_attributes_with_nested_matches, :only => [:create, :update]

  #################################
  #         ADMINS ONLY           #
  #################################
  
  # GET /matchdays
  def index
    @matchdays = Matchday.all
  end

  # GET /matchdays/1
  def show
    @matchday = Matchday.find(params[:id])
  end
  
  # GET /matchdays/new
  def new
    @matchday = Matchday.new
  end

  # GET /matchdays/1/edit
  def edit
    @matchday = Matchday.find(params[:id])
  end

  # POST /matchdays
  def create
    @matchday = Matchday.new(@matchday_attributes)
    @matches.each{|match| match.matchday = @matchday}
    @matchday.matches += @matches

    if @matchday.save
      redirect_to @matchday, notice: 'Matchday was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /matchdays/1
  def update    
    @matchday = Matchday.find(params[:id])
    @matches.each{|match| match.matchday = @matchday}
    @matchday.matches += @matches

    if @matchday.update_attributes(@matchday_attributes)
      redirect_to @matchday, notice: 'Matchday was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /matchdays/1
  def destroy
    @matchday = Matchday.find(params[:id])
    @matchday.destroy

    redirect_to matchdays_url
  end
  
  protected
  
  def create_attributes_with_nested_matches
    csv = params["csv"]
    @matches = Match.build_from_csv(csv, col_sep: ";", row_sep: "\r\n")
    @matchday_attributes = params[:matchday].except("csv")
  end
end
