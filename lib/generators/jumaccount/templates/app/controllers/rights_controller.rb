# <%= generator_label_rb %>
class RightsController < ApplicationController
  helper ApplicationHelper

  before_action :set_right, only: [:show, :edit, :update, :destroy, 
                                   :usershow, :useredit, :userupdate, :userdestroy]
  before_action :set_actuser, only: [:usershow, :useredit, :userupdate, :userdestroy, 
                                     :userindex, :usercreate, :usernew, :userchoose]
  
  # GET /rights
  # GET /rights.json
  def index
    @rights = Right.all
  end

  # GET /users/1/rights
  def userindex
    @rights = Right.where(user_id: @actuser)
    render :userindex
  end

  # GET /rights/1
  # GET /rights/1.json
  def show
  end
  # GET /users/1/rights/1
  # GET /users/1/rights/1.json
  def usershow
    render :usershow
  end

  # GET /users/user_id/rights/new
  def usernew
    @right = Right.new
    @right.user_id = @actuser.id
    render :usernew
  end

  # GET /rights/new
  def new
   @right = Right.new
  end

  # GET /rights/1/useredit
  def useredit
    authorize @right
    render :useredit
  end
  
  # GET /rights/1/edit
  def edit
  end

  # GET /users/user_id/rights/1/edit
  def userchoose
    @actuser = User.find(params[:user_id])
    @right = Right.find(params[:id])
    authorize @right
    session[:current_right] = @right
    redirect_to (request.referrer || root_path) # Send them back to them page they came from, or to the root page.
  end

  # POST /rights
  # POST /rights.json
  def usercreate
    @right = Right.new(right_params)

    respond_to do |format|
      if @right.save
        format.html { redirect_to user_rights_path(@actuser), notice: "Right: #{I18n.t('helpers.saved')}" }
        format.json { render :show, status: :created, location: @right }
      else
        format.html { render :usernew }
        format.json { render json: @right.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /rights
  # POST /rights.json
  def create
    @right = Right.new(right_params)

    respond_to do |format|
      if @right.save
        format.html { redirect_to rights_url, notice: "Right: #{I18n.t('helpers.saved')}" }
        format.json { render :show, status: :created, location: @right }
      else
        format.html { render :new }
        format.json { render json: @right.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1/rights/1
  # PATCH/PUT /users/1/rights/1.json
  def userupdate
    respond_to do |format|
      if @right.update(right_params)
        format.html { redirect_to user_rights_path(@actuser), notice: "Right: #{I18n.t('helpers.saved')}" }
        format.json { render :show, status: :ok, location: @right }
      else
        format.html { render :useredit }
        format.json { render json: @right.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rights/1
  # PATCH/PUT /rights/1.json
  def update
    respond_to do |format|
      if @right.update(right_params)
        format.html { redirect_to rights_url, notice: "Right: #{I18n.t('helpers.saved')}" }
        format.json { render :show, status: :ok, location: @right }
      else
        format.html { render :edit }
        format.json { render json: @right.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1/rights/1
  # DELETE /users/1/rights/1.json
  def userdestroy
    @right.destroy
    respond_to do |format|
      format.html { redirect_to user_rights_path(@actuser), notice: "Right: #{I18n.t('helpers.deleted')}" }
      format.json { head :no_content }
    end
  end
  
  # DELETE /rights/1
  # DELETE /rights/1.json
  def destroy
    @right.destroy
    respond_to do |format|
      format.html { redirect_to rights_url, notice: "Right: #{I18n.t('helpers.deleted')}" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_right
      @right = Right.find(params[:id])
    end
    def set_actuser
      @actuser = User.find(params[:user_id])
    end
    

    # Never trust parameters from the scary internet, only allow the white list through.
    def right_params
      params.require(:right).permit(:right_role, :user_id, :company_id, :team_id)
    end
end
