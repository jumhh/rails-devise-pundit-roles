# <%= generator_label_rb %>
class ApplicationPolicy
  attr_reader :current_user, :current_right, :model

  def initialize(current_authority, model)
    @current_user = current_authority.user
    @current_right = current_authority.right
    @model = model
  end
  
  def user_admission?
    @current_user.id == @model.user_id
  end
  
  def team_admission?
    @current_right.team_id == @model.team_id
  end
  
  def company_admission?
    @current_right.company_id == @model.company_id
  end
  
  def full_admission?
    @current_user.id == @model.user_id &&
    @current_right.team_id == @model.team_id &&
    @current_right.company_id == @model.company_id    
  end
  
  class Scope
    attr_reader :current_user, :current_right, :scope

    def initialize(current_authority, scope)
      @current_user = current_authority.user
      @current_right = current_authority.right
      @scope = scope
    end

    # No special rights for admins on domain data (in contrast to administrative data)
    def user_admission_scope
      #if @current_user.admin?
      #  scope.all
      #else
        scope.where(:user_id => @current_user.id)
      #end
    end

    def team_admission_scope
      #if @current_user.admin?
      #  scope.all
      #else
        scope.where(:team_id => @current_right.team_id)
      #end
    end
    
    def company_admission_scope
      #if @current_user.admin?
      #  scope.all
      #else
        scope.where(:company_id => @current_right.company_id)
      #end
    end

    def full_admission_scope
      #if @current_user.admin?
      #  scope.all
      #else
        scope.where(:company_id => @current_right.company_id, 
                    :team_id => @current_right.team_id,
                    :user_id => @current_user.id)
      #end
    end
    
  end # class Scope
end # class ApplicationPolicy