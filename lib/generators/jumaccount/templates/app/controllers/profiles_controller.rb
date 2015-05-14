# <%= generator_label_rb %>
class ProfilesController < ApplicationController

  helper ProfilesHelper

  before_action :set_profile, only: [:show, :edit, :update, :destroy]

  # GET /profiles
  # GET /profiles.json
  def index
    @profiles = Profile.all
    authorize Profile
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
    session[:return_to] = request.referer
    authorize @profile
  end

  # GET /profiles/new
  def new
    session[:return_to] = request.referer
    @profile = Profile.new
    authorize @profile
  end

  # GET /profiles/1/edit
  def edit
    session[:return_to] = request.referer
    authorize @profile
  end

  # GET /users/profiles/edit
  def useredit
    session[:return_to] = request.referer
    @profile = Profile.find_by user_id: current_user.id
    if (@profile == nil) 
       @profile = Profile.new 
       @profile.user_id = current_user.id
    end
    authorize @profile
    render :edit
  end

  # GET /users/profiles/quit
  def quit
    redirect_to session.delete(:return_to) || :back
  end

  # POST /profiles
  # POST /profiles.json
  def create
    @profile = Profile.new(profile_params)
    authorize @profile

    respond_to do |format|
      if @profile.save
        format.html { redirect_to quit_user_profile_path, notice: "Profile: #{I18n.t('helpers.saved')}" }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profiles/1
  # PATCH/PUT /profiles/1.json
  def update
    authorize @profile
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to quit_user_profile_path , notice: "Profile: #{I18n.t('helpers.saved')}" }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render :edit }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    authorize @profile
    @profile.destroy
    respond_to do |format|
      format.html { redirect_to profiles_url, notice: "Profile: #{I18n.t('helpers.deleted')}" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_params
      params.require(:profile).permit(:profile_first_name, :profile_last_name, :user_id, :profile_preferred_right_id)
    end
end
