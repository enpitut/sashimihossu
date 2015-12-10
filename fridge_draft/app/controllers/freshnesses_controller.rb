class FreshnessesController < ApplicationController
  before_action :set_freshness, only: [:show, :edit, :update, :destroy]

  # GET /freshnesses
  # GET /freshnesses.json
  def index
    @freshnesses = Freshness.all
  end

  # GET /freshnesses/1
  # GET /freshnesses/1.json
  def show
    # @freshness = Freshness.find(params[:id])
    # respond_to do |format|
    #   format.html { render :show }
    #   format.json { render :show, status: :ok, location: @freshness }
    # end
  end

  # GET /freshnesses/new
  def new
    @freshness = Freshness.new
  end

  # GET /freshnesses/1/edit
  def edit
  end

  # POST /freshnesses
  # POST /freshnesses.json
  def create
    @freshness = Freshness.new(freshness_params)

    respond_to do |format|
      if @freshness.save
        format.html { redirect_to @freshness, notice: 'Freshness was successfully created.' }
        format.json { render :show, status: :created, location: @freshness }
      else
        format.html { render :new }
        format.json { render json: @freshness.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /freshnesses/1
  # PATCH/PUT /freshnesses/1.json
  def update
    respond_to do |format|
      if @freshness.update(freshness_params)
        format.html { redirect_to @freshness, notice: 'Freshness was successfully updated.' }
        format.json { render :show, status: :ok, location: @freshness }
      else
        format.html { render :edit }
        format.json { render json: @freshness.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /freshnesses/1
  # DELETE /freshnesses/1.json
  def destroy
    @freshness.destroy
    respond_to do |format|
      format.html { redirect_to freshnesses_url, notice: 'Freshness was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  #=================================================================================================================================================
  # アイテム名から賞味期間をとってくる
  def freshness_by_name
    @freshness = 0
    if Freshness.where(:name => params['name']).exists?
      @freshness = Freshness.where(:name => params['name']).first().freshness;
    end
    respond_to do |format|
      format.json { render :json => @freshness }
      # format.json { render :json => @freshness, location: @freshness }
    end
  end


  #=================================================================================================================================================
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_freshness
      @freshness = Freshness.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def freshness_params
      params.require(:freshness).permit(:name, :freshness)
    end
end
