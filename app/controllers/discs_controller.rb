class DiscsController < ApplicationController
  before_filter :authenticate_user! # jumadmission generator
  after_action :verify_authorized, :except => :index # jumadmission generator
  after_action :verify_policy_scoped, :only => :index # jumadmission generator
  before_action :set_disc, only: [:show, :edit, :update, :destroy]

  # GET /discs
  # GET /discs.json
  def index
    @discs = policy_scope(Disc) # jumadmission generator index
 #     @discs = Disc.all
  end

  # GET /discs/1
  # GET /discs/1.json
  def show
    authorize @disc # jumadmission generator show
  end

  # GET /discs/new
  def new
    @disc = Disc.new
    authorize @disc # jumadmission generator new
  end

  # GET /discs/1/edit
  def edit
    authorize @disc # jumadmission generator edit
  end

  # POST /discs
  # POST /discs.json
  def create
    @disc = Disc.new(disc_params).set_admission(current_right) # jumadmission generator: set_admission
    authorize @disc # jumadmission generator create

    respond_to do |format|
      if @disc.save
        format.html { redirect_to action: :index, notice: "Disc: #{I18n.t('helpers.saved')}" }
        format.json { render :show, status: :created, location: @disc }
      else
        format.html { render :new }
        format.json { render json: @disc.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /discs/1
  # PATCH/PUT /discs/1.json
  def update
    authorize @disc # jumadmission generator update
    respond_to do |format|
      if @disc.update(disc_params)
        format.html { redirect_to action: :index, notice: "Disc: #{I18n.t('helpers.saved')}" }
        format.json { render :show, status: :ok, location: @disc }
      else
        format.html { render :edit }
        format.json { render json: @disc.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /discs/1
  # DELETE /discs/1.json
  def destroy
    authorize @disc # jumadmission generator destroy
    @disc.destroy
    respond_to do |format|
      format.html { redirect_to discs_url, notice: "Disc: #{I18n.t('helpers.deleted')}" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_disc
      @disc = Disc.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def disc_params
      params.require(:disc).permit(:feld1, :feld2, :tracks, :user_id, :company_id, :team_id)
    end
end
